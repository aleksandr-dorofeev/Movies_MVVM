// MovieDetailViewModelTests.swift
// Copyright © Aleksandr Dorofeev. All rights reserved.

import XCTest

@testable import Movies_MVVM

/// Movie detail view model tests
final class MovieDetailViewModelTests: XCTestCase {
    // MARK: - Private Constants

    private enum Constants {
        static let movieIdString = "550"
        static let emptyString = ""
    }

    // MARK: - Private properties

    private var imageNetworkService = ImageNetworkService()
    private var fileManagerService = FileManagerService()
    private var viewModel: MovieDetailViewModelProtocol?
    private var networkService = MockNetworkService()
    private var imageService = MockImageService()
    private var dataService = DataService()

    // MARK: - Public methods

    override func setUp() {
        imageService = MockImageService(
            imageNetworkService: imageNetworkService,
            fileManagerService: fileManagerService
        )
        viewModel = MovieDetailViewModel(
            networkService: networkService,
            imageService: imageService,
            id: Constants.movieIdString,
            dataService: dataService
        )
    }

    override func tearDown() {
        viewModel = nil
    }

    func testBackPrevious() {
        var isWorkHandler = false
        viewModel?.backHandler = {
            isWorkHandler = true
        }
        viewModel?.backPreviousScreen()
        XCTAssertEqual(isWorkHandler, true)
    }

    func testSuccessActorImage() {
        var imageData: Data?
        viewModel?.getActorImage(actorImagePath: Constants.emptyString) { data in
            imageData = data
        }
        XCTAssertNotNil(imageData)
    }

    func testSuccessPoster() {
        var imageData: Data?
        viewModel?.getPosterImage(posterPath: Constants.emptyString) { data in
            imageData = data
        }
        XCTAssertNotNil(imageData)
    }
}
