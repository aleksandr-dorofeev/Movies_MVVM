// MockDataService.swift
// Copyright © Aleksandr Dorofeev. All rights reserved.

import Foundation

@testable import Movies_MVVM

/// Mock data service
final class MockDataService: DataServiceProtocol {
    // MARK: - Public properties

    var dataMovies: [Movie]?
    var dataMovieDetail: MovieDetail?

    // MARK: - Public methods

    func writeMovieData(movies: [Movie], category: String) {
        dataMovies = movies
    }

    func readMovieData(category: String) -> [Movie]? {
        dataMovies
    }

    func writeMovieDetailData(movieDetail: MovieDetail, id: Int) {
        dataMovieDetail = movieDetail
    }

    func readMovieDetailData(id: Int) -> MovieDetail? {
        dataMovieDetail
    }
}
