// MovieListViewModel.swift
// Copyright © RoadMap. All rights reserved.

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
    var isSearching = false
    var currentPage = 1
    var onMovieDetailHandler: StringVoidHandler?
    var movieListStateHandler: ((MovieListState) -> ())?

    // MARK: - Private properties

    private let networkService: NetworkServiceProtocol
    private var currentCategoryMovies: CurrentCategoryOfMovies = .popular

    private(set) var imageService: ImageServiceProtocol
    private(set) var movies: [Movie] = []
    private(set) var filteredMovies: [Movie]?

    // MARK: - Initializer

    init(
        networkService: NetworkServiceProtocol,
        imageService: ImageServiceProtocol
    ) {
        self.networkService = networkService
        self.imageService = imageService
    }

    // MARK: - Public methods

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

    func fetchMoreMovies() {
        guard !isFetchingMore else { return }
        currentPage += 1
        fetchMovies()
    }

    func filterContentForSearch(_ searchText: String) {
        isSearching = true
        filteredMovies = movies.filter {
            $0.title.lowercased().contains(searchText.lowercased())
        }
        movieListStateHandler?(.success)
    }

    func showMovieDetail(id: String) {
        onMovieDetailHandler?(id)
    }

    // MARK: - Private methods

    func fetchMovies() {
        isFetchingMore = true
        networkService.fetchMovies(
            categoryOfMovies: currentCategoryMovies.rawValue,
            page: currentPage
        ) { result in
            switch result {
            case let .success(movies):
                guard let movies = movies?.results else { return }
                self.movies += movies
                self.movieListStateHandler?(.success)
            case let .failure(error):
                self.movieListStateHandler?(.failure(error))
            }
            self.isFetchingMore = false
        }
    }

    private func removeMovies() {
        movies.removeAll()
        currentPage = 1
    }
}
