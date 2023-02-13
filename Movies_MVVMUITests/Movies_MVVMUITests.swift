// Movies_MVVMUITests.swift
// Copyright © Aleksandr Dorofeev. All rights reserved.

import XCTest

/// UI tests
final class MoviesMVVMUITests: XCTestCase {
    // MARK: - Private Constants

    private enum Constants {
        static let moviesCollectionViewID = "Movies"
        static let movieDetailTableViewID = "MovieDetail"
        static let topRatedButtonID = "Top"
        static let backButtonID = "Back"
    }

    // MARK: - Private properties

    private let app = XCUIApplication()

    // MARK: - Public methods

    override func setUp() {
        continueAfterFailure = false
        app.launch()
        super.setUp()
    }

    func testHasACollectionView() {
        XCTAssertNotNil(app.collectionViews.matching(identifier: Constants.moviesCollectionViewID))
    }

    func testMovie() {
        let moviesCollectionView = app.collectionViews.containing(
            .collectionView,
            identifier: Constants.moviesCollectionViewID
        )
        XCTAssertNotNil(moviesCollectionView)
        moviesCollectionView.element.swipeDown()
        moviesCollectionView.element.swipeUp()
        app.buttons[Constants.topRatedButtonID].tap()
        moviesCollectionView.element.swipeUp()
        moviesCollectionView.element.swipeUp()
        moviesCollectionView.element.swipeUp()
        app.collectionViews.cells.element(boundBy: 0).tap()
        let movieDetailTable = app.tables[Constants.movieDetailTableViewID]
        XCTAssertNotNil(movieDetailTable)
        movieDetailTable.swipeUp()
        movieDetailTable.swipeUp()
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
