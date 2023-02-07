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
    var successHandler: (() -> ())?
    var failureHandler: ((Error) -> ())?
    var onMovieDetailHandler: ((String) -> Void)?

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
        fetchMovies(categoryOfMovies: currentCategoryMovies.rawValue)
    }

    // MARK: - Public methods

    private func fetchMovies(categoryOfMovies: String?) {
        isFetchingMore = true
        networkService.fetchMovies(
            categoryOfMovies: categoryOfMovies,
            page: currentPage
        ) { result in
            switch result {
            case let .success(movies):
                guard let movies = movies?.results else { return }
                self.movies += movies
                self.successHandler?()
            case let .failure(error):
                self.failureHandler?(error)
            }
            self.isFetchingMore = false
        }
    }

    func fetchPopularMovies() {
        removeMovies()
        currentCategoryMovies = .popular
        fetchMovies(categoryOfMovies: currentCategoryMovies.rawValue)
    }

    func fetchTopRatedMovies() {
        removeMovies()
        currentCategoryMovies = .topRating
        fetchMovies(categoryOfMovies: currentCategoryMovies.rawValue)
    }

    func fetchUpcomingMovies() {
        removeMovies()
        currentCategoryMovies = .upComing
        fetchMovies(categoryOfMovies: currentCategoryMovies.rawValue)
    }

    func fetchMoreMovies() {
        guard !isFetchingMore else { return }
        currentPage += 1
        fetchMovies(categoryOfMovies: currentCategoryMovies.rawValue)
    }

    func filterContentForSearch(_ searchText: String) {
        isSearching = true
        filteredMovies = movies.filter {
            $0.title.lowercased().contains(searchText.lowercased())
        }
        successHandler?()
    }

    func showMovieDetail(id: String) {
        onMovieDetailHandler?(id)
    }

    // MARK: - Private methods

    private func removeMovies() {
        movies.removeAll()
        currentPage = 1
    }
}
