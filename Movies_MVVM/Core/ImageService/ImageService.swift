// ImageService.swift
// Copyright © Aleksandr Dorofeev. All rights reserved.

import Foundation

/// Loading image
final class ImageService: ImageServiceProtocol {
    // MARK: - Public properties

    // MARK: - Initializers

    init(proxy: ProxyProtocol) {
        self.proxy = proxy
    }

    // MARK: - Private properties

    private let proxy: ProxyProtocol

    // MARK: - Public methods

    func getImage(imagePath: String, completion: @escaping (Result<Data?, Error>) -> ()) {
        proxy.getImage(imagePath: imagePath) { result in
            switch result {
            case let .success(data):
                completion(.success(data))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
