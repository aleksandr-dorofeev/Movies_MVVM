// MovieListViewModelTests.swift
// Copyright © Aleksandr Dorofeev. All rights reserved.

import XCTest

@testable import Movies_MVVM

/// Movie list view model tests
final class MovieListViewModelTests: XCTestCase {
    // MARK: - Private enums

    private enum CurrentCategoryOfMovies {
        case popular
        case topRated
        case upcoming
    }

    // MARK: - Private Constants

    private enum Constants {
        static let mockKeyString = "mockKey"
        static let mockId = "1"
        static let mockFilterText = "text"
    }

    // MARK: - Private properties

    private var viewModel: MovieListViewModelProtocol?
    private var networkService = MockNetworkService()
    private var imageService = MockImageService()
    private var keychainService = MockKeychainService()
    private var dataService = DataService()
    private var currentCategoryMovies: CurrentCategoryOfMovies = .popular

    // MARK: - Public methods

    override func setUp() {
        viewModel = MovieListViewModel(
            networkService: networkService,
            imageService: imageService,
            dataService: dataService,
            keychainService: keychainService
        )
        super.setUp()
    }

    override func tearDown() {
        viewModel = nil
        super.setUp()
    }

    func testSetUpAliKey() {
        viewModel?.setApiKey(text: Constants.mockKeyString)
        XCTAssertNotNil(keychainService.keyValue)
        guard let apiKey = keychainService.keyValue else { return }
        XCTAssertEqual(apiKey, Constants.mockKeyString)
    }

    func testGetApiKey() {
        viewModel?.getApiKey()
        let apiKey = keychainService.readKey()
        XCTAssertEqual(apiKey, Constants.mockKeyString)
    }

    func testSpecificCategory() {
        viewModel?.fetchSpecificCategory(tag: 0)
        XCTAssertEqual(currentCategoryMovies, .popular)
    }

    func testShowDetailModule() {
        var id: String?
        viewModel?.onMovieDetailHandler = { idValue in
            id = idValue
        }
        viewModel?.showMovieDetail(id: Constants.mockId)
        XCTAssertEqual(Constants.mockId, id)
    }

    func testFetchMoreData() {
        viewModel?.currentPage = 1
        viewModel?.fetchMoreMovies()
        XCTAssertEqual(viewModel?.currentPage, 2)
    }

    func testFilterSearchMethod() {
        XCTAssertNil(viewModel?.filteredMovies)
        viewModel?.filterContentForSearch(Constants.mockFilterText)
        XCTAssertNotNil(viewModel?.filteredMovies)
    }
}
