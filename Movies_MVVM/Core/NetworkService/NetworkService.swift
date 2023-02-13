// NetworkService.swift
// Copyright © Aleksandr Dorofeev. All rights reserved.

import Foundation

/// Network layer
final class NetworkService: NetworkServiceProtocol {
    // MARK: - Private properties

    private let networkServiceCore: NetworkServiceCoreProtocol?

    // MARK: Initializers

    init(networkServiceCore: NetworkServiceCoreProtocol) {
        self.networkServiceCore = networkServiceCore
    }

    // MARK: - Public methods

    func fetchMovies(
        categoryOfMovies: String?,
        page: Int,
        completion: @escaping (Result<MovieResults?, Error>) -> Void
    ) {
        networkServiceCore?.getJson(id: nil, categoryOfMovies: categoryOfMovies, page: page, completion: completion)
    }

    func fetchDetails(id: String, completion: @escaping (Result<MovieDetail, Error>) -> Void) {
        networkServiceCore?.getJson(id: id, categoryOfMovies: nil, page: nil, completion: completion)
    }

    func fetchCast(id: String, completion: @escaping (Result<CastResult?, Error>) -> Void) {
        networkServiceCore?.getJson(id: id, categoryOfMovies: nil, page: nil, completion: completion)
    }
}
