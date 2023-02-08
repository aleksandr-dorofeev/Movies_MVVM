// ImageService.swift
// Copyright © Aleksandr Dorofeev. All rights reserved.

import Foundation

/// Loading image
final class ImageService: ImageServiceProtocol {
    // MARK: - Private properties

    private let imageNetworkService = ImageNetworkService()
    private let fileManagerService = FileManagerService()

    // MARK: - Public methods

    func getImage(imagePath: String, completion: @escaping (Result<Data?, Error>) -> ()) {
        let proxy = Proxy(imageNetworkService: imageNetworkService, fileManagerService: fileManagerService)
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
