// Proxy.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Proxy
final class Proxy: ProxyProtocol {
    // MARK: - Private properties

    private let imageNetworkService: ImageNetworkServiceProtocol
    private let fileManagerService: FileManagerServiceProtocol

    // MARK: - Initializer

    init(imageNetworkService: ImageNetworkServiceProtocol, fileManagerService: FileManagerServiceProtocol) {
        self.imageNetworkService = imageNetworkService
        self.fileManagerService = fileManagerService
    }

    // MARK: - Public methods

    func getImage(imagePath: String, completion: @escaping (Result<Data, Error>) -> ()) {
        guard let image = fileManagerService.getImageDataFromDisk(url: imagePath) else {
            imageNetworkService.fetchImageData(imagePath: imagePath) { result in
                switch result {
                case let .success(data):
                    self.fileManagerService.saveImageToFile(url: imagePath, data: data)
                    completion(.success(data))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
            return
        }
        completion(.success(image))
    }
}
