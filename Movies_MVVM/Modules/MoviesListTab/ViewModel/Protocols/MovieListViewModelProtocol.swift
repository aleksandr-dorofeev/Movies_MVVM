// MovieListViewModelProtocol.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Protocol for movie list view model
protocol MovieListViewModelProtocol {
    var currentPage: Int { get set }
    var isFetchingMore: Bool { get set }
    var isSearching: Bool { get set }
    var successHandler: (() -> ())? { get set }
    var failureHandler: ((Error) -> ())? { get set }
    var onMovieDetailHandler: ((String) -> Void)? { get set }

    var filteredMovies: [Movie]? { get }
    var movies: [Movie] { get }
    var imageService: ImageServiceProtocol { get }

    func fetchMoreMovies()
    func fetchPopularMovies()
    func fetchTopRatedMovies()
    func fetchUpcomingMovies()
    func filterContentForSearch(_ searchText: String)
    func showMovieDetail(id: String)
}
