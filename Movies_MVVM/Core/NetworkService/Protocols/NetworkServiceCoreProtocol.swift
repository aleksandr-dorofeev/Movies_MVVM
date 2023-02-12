// NetworkServiceCoreProtocol.swift
// Copyright © Aleksandr Dorofeev. All rights reserved.

import Foundation

/// Network service core protocol
protocol NetworkServiceCoreProtocol {
    func getJson<T: Decodable>(
        id: String?,
        categoryOfMovies: String?,
        page: Int?,
        completion: @escaping (Result<T, Error>) -> Void
    )
}
