// NetworkServiceProtocol.swift
// Copyright © Aleksandr Dorofeev. All rights reserved.

import Foundation

/// Network service protocol
protocol NetworkServiceProtocol {
    func fetchMovies(
        categoryOfMovies: String?,
        page: Int,
        completion: @escaping (Result<MovieResults?, Error>) -> Void
    )
    func fetchDetails(
        id: String,
        completion: @escaping (Result<MovieDetail, Error>) -> Void
    )
    func fetchCast(
        id: String,
        completion: @escaping (Result<CastResult?, Error>) -> Void
    )
}
