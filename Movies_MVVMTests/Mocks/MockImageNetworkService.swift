// MockImageNetworkService.swift
// Copyright © Aleksandr Dorofeev. All rights reserved.

import Foundation

@testable import Movies_MVVM

/// Mock image network service
final class MockImageNetworkService: ImageNetworkServiceProtocol {
    // MARK: - Private Constants

    private enum Constants {
        static let emptyString = ""
        static let errorMessage = "No data"
    }

    // MARK: - Private properties

    private var imageData: Data?

    // MARK: - Initializers

    convenience init(imageData: Data?) {
        self.init()
        self.imageData = imageData
    }

    // MARK: - Public methods

    func fetchImageData(imagePath: String, completion: @escaping (Result<Data, Error>) -> ()) {
        if imageData != nil {
            guard let imageData = imageData else { return }
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
