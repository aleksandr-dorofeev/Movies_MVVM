// DataServiceProtocol.swift
// Copyright © Aleksandr Dorofeev. All rights reserved.

import Foundation

/// Protocol for data service
protocol DataServiceProtocol {
    func writeMovieData(movies: [Movie], category: String)
    func readMovieData(category: String) -> [Movie]?
    func writeMovieDetailData(movieDetail: MovieDetail, id: Int)
    func readMovieDetailData(id: Int) -> MovieDetail?
}
