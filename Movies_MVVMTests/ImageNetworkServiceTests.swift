// ImageNetworkServiceTests.swift
// Copyright © Aleksandr Dorofeev. All rights reserved.

import XCTest

@testable import Movies_MVVM

/// Image network service tests
final class ImageNetworkServiceTests: XCTestCase {
    // MARK: - Private Constants

    private enum Constants {
        static let emptyString = ""
    }

    // MARK: - Private properties

    private var imageNetworkService: ImageNetworkServiceProtocol?

    // MARK: - Public methods

    override func setUp() {
        imageNetworkService = MockImageNetworkService()
    }

    override func tearDown() {
        imageNetworkService = nil
    }

    func testSuccessImageRequest() {
        let mockImageData = Data()
        imageNetworkService = MockImageNetworkService(imageData: mockImageData)
        var catchImageData: Data?
        imageNetworkService?.fetchImageData(imagePath: Constants.emptyString) { result in
            switch result {
            case let .success(data):
                catchImageData = data
            case .failure:
                break
            }
        }
        XCTAssertNotNil(catchImageData)
    }

    func testFailureImageRequest() {
        imageNetworkService = MockImageNetworkService(imageData: nil)
        var catchError: Error?
        imageNetworkService?.fetchImageData(imagePath: Constants.emptyString) { result in
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
