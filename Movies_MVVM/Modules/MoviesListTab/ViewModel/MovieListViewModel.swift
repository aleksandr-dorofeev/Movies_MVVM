// MovieListViewModel.swift
// Copyright © Aleksandr Dorofeev. All rights reserved.

import Foundation

/// Movie list view model
final class MovieListViewModel: MovieListViewModelProtocol {
    // MARK: - Private Constants

    private enum CurrentCategoryOfMovies: String {
        case popular
        case topRating = "top_rated"
        case upComing = "upcoming"
    }

    private enum Constants {
        static let emptyString = ""
    }

    // MARK: - Public properties

    var isFetchingMore = false
    var isLastPage = false
    var isSearching = false
    var currentPage = 1
    var onMovieDetailHandler: StringVoidHandler?
    var movieListState: MovieListState = .initial {
        didSet {
            reloadViewHandler?()
        }
    }

    var reloadViewHandler: VoidHandler?
    var apiKeyHandler: VoidHandler?

    // MARK: - Private properties

    private let dataService: DataServiceProtocol
    private let networkService: NetworkServiceProtocol
    private let keychainService: KeychainServiceProtocol
    private var currentCategoryMovies: CurrentCategoryOfMovies = .popular

    private(set) var imageService: ImageServiceProtocol
    private(set) var filteredMovies: [Movie]?
    private(set) var movies: [Movie] = []

    // MARK: - Initializer

    init(
        networkService: NetworkServiceProtocol,
        imageService: ImageServiceProtocol,
        dataService: DataServiceProtocol,
        keychainService: KeychainServiceProtocol
    ) {
        self.networkService = networkService
        self.imageService = imageService
        self.dataService = dataService
        self.keychainService = keychainService
    }

    // MARK: - Public methods

    func getMovies() {
        guard let movies = dataService.readMovieData(category: currentCategoryMovies.rawValue) else { return }
        if !movies.isEmpty {
            self.movies = movies
            movieListState = .success
        } else {
            fetchMovies()
        }
    }

    func fetchSpecificCategory(tag: Int) {
        switch tag {
        case 0:
            removeMovies()
            currentCategoryMovies = .popular
        case 1:
            removeMovies()
            currentCategoryMovies = .topRating
        case 2:
            removeMovies()
            currentCategoryMovies = .upComing
        default:
            break
        }
        fetchMovies()
    }

    func getApiKey() {
        if keychainService.readKey() != nil {
            getMovies()
        } else {
            apiKeyHandler?()
        }
    }

    func setApiKey(text: String) {
        keychainService.writeKey(text: text)
        fetchMovies()
    }

    func fetchMoreMovies() {
        guard
            !isFetchingMore,
            !isLastPage
        else { return }
        currentPage += 1
        fetchMovies()
    }

    func filterContentForSearch(_ searchText: String) {
        isSearching = true
        filteredMovies = movies.filter {
            $0.title.lowercased().contains(searchText.lowercased())
        }
        reloadViewHandler?()
    }

    func showMovieDetail(id: String) {
        onMovieDetailHandler?(id)
    }

    func getPoster(currentPosterPath: String, movie: Movie, completion: @escaping (Data) -> ()) {
        var posterPath = currentPosterPath
        posterPath = movie.posterPath ?? Constants.emptyString
        imageService.getImage(imagePath: posterPath) { result in
            switch result {
            case let .success(data):
                guard
                    movie.posterPath == posterPath,
                    let data = data
                else { return }
                completion(data)
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }

    // MARK: - Private methods

    private func fetchMovies() {
        isFetchingMore = true
        networkService.fetchMovies(
            categoryOfMovies: currentCategoryMovies.rawValue,
            page: currentPage
        ) { result in
            switch result {
            case let .success(movies):
                guard let movies = movies?.results else { return }
                if movies.isEmpty {
                    self.isLastPage = true
                }
                self.movies += movies
                self.dataService.writeMovieData(movies: self.movies, category: self.currentCategoryMovies.rawValue)
                self.movieListState = .success
            case let .failure(error):
                self.movieListState = .failure(error)
            }
            self.isFetchingMore = false
        }
    }

    private func removeMovies() {
        movies.removeAll()
        isLastPage = false
        currentPage = 1
    }
}
