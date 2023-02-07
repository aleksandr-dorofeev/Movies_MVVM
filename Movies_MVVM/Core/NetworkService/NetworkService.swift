// NetworkService.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Network layer
final class NetworkService: NetworkServiceCore, NetworkServiceProtocol {
    // MARK: - Public methods

    func fetchMovies(
        categoryOfMovies: String?,
        page: Int,
        completion: @escaping (Result<MovieResults?, Error>) -> Void
    ) {
        getJson(id: nil, categoryOfMovies: categoryOfMovies, page: page, completion: completion)
    }

    func fetchDetails(id: String, completion: @escaping (Result<MovieDetail, Error>) -> Void) {
        getJson(id: id, categoryOfMovies: nil, page: nil, completion: completion)
    }

    func fetchCast(id: String, completion: @escaping (Result<CastResult?, Error>) -> Void) {
        getJson(id: id, categoryOfMovies: nil, page: nil, completion: completion)
    }
}
