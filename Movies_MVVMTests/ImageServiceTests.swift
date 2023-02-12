// ImageServiceTests.swift
// Copyright © Aleksandr Dorofeev. All rights reserved.

import XCTest

@testable import Movies_MVVM

/// Image service tests
final class ImageServiceTests: XCTestCase {
    // MARK: - Private Constants

    private enum Constants {
        static let emptyString = ""
    }

    // MARK: - Private properties

    private var imageNetworkService = ImageNetworkService()
    private var fileManagerService = FileManagerService()
    private var imageService: ImageServiceProtocol?

    // MARK: - Public methods

    override func setUp() {
        imageService = MockImageService()
    }

    override func tearDown() {
        imageService = nil
    }

    func testSuccessImage() {
        imageService = MockImageService(
            imageNetworkService: imageNetworkService,
            fileManagerService: fileManagerService
        )
        var catchImageData: Data?
        imageService?.getImage(imagePath: Constants.emptyString) { result in
            switch result {
            case let .success(data):
                catchImageData = data
            case .failure:
                break
            }
        }
        XCTAssertNotNil(catchImageData)
    }

    func testFailureImage() {
        imageService = MockImageService(
            imageNetworkService: nil,
            fileManagerService: nil
        )
        var catchError: Error?
        imageService?.getImage(imagePath: Constants.emptyString) { result in
            switch result {
            case .success:
                break
            case let .failure(error):
                catchError = error
            }
        }
        XCTAssertNotNil(catchError)
    }
}
