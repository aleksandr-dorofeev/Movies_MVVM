// MovieListViewModelProtocol.swift
// Copyright © Aleksandr Dorofeev. All rights reserved.

import Foundation

/// Protocol for movie list view model
protocol MovieListViewModelProtocol {
    var currentPage: Int { get set }
    var isFetchingMore: Bool { get set }
    var isSearching: Bool { get set }
    var onMovieDetailHandler: StringVoidHandler? { get set }
    var reloadViewHandler: VoidHandler? { get set }
    var apiKeyHandler: VoidHandler? { get set }
    var movieListState: MovieListState { get set }

    var filteredMovies: [Movie]? { get }
    var movies: [Movie] { get }

    func getApiKey()
    func setApiKey(text: String)
    func fetchMoreMovies()
    func fetchSpecificCategory(tag: Int)
    func filterContentForSearch(_ searchText: String)
    func showMovieDetail(id: String)
    func getPoster(currentPosterPath: String, movie: Movie, completion: @escaping (Data) -> ())
}
