// MockImageService.swift
// Copyright © Aleksandr Dorofeev. All rights reserved.

import Foundation

@testable import Movies_MVVM

/// Mock image service
final class MockImageService: ImageServiceProtocol {
    // MARK: - Private Constants

    private enum Constants {
        static let emptyString = ""
        static let errorMessage = "Services is nil"
    }

    // MARK: - Private properties

    private var imageNetworkService: ImageNetworkServiceProtocol?
    private var fileManagerService: FileManagerServiceProtocol?

    // MARK: - Initializers

    convenience init(
        imageNetworkService: ImageNetworkServiceProtocol?,
        fileManagerService: FileManagerServiceProtocol?
    ) {
        self.init()
        self.imageNetworkService = imageNetworkService
        self.fileManagerService = fileManagerService
    }

    // MARK: - Public methods

    func getImage(imagePath: String, completion: @escaping (Result<Data?, Error>) -> ()) {
        if imageNetworkService != nil, fileManagerService != nil {
            let imageData = Data()
            completion(.success(imageData))
        } else {
            let error = NSError(
                domain: Constants.emptyString,
                code: 401,
                userInfo: [NSLocalizedDescriptionKey: Constants.errorMessage]
            ) as Error
            completion(.failure(error))
        }
    }
}
