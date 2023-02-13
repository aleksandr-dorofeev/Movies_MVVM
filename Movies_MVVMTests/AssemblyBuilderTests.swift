// AssemblyBuilderTests.swift
// Copyright © Aleksandr Dorofeev. All rights reserved.

import XCTest

@testable import Movies_MVVM

/// Assembly tests
final class AssemblyBuilderTests: XCTestCase {
    // MARK: - Private Constants

    private enum Constants {
        static let testIDString = "1"
    }

    // MARK: - Private properties

    private var assemblyModuleBuilder: AssemblyModuleBuilderProtocol?

    // MARK: - Public methods

    override func setUp() {
        assemblyModuleBuilder = AssemblyModuleBuilder()
        super.setUp()
    }

    override func tearDown() {
        assemblyModuleBuilder = nil
        super.tearDown()
    }

    func testMakeMoviesModule() {
        let moviesModule = assemblyModuleBuilder?.makeMovieListModule()
        XCTAssertTrue(moviesModule is MovieListViewController)
    }

    func testMakeDetailMoviesModule() {
        let movieDetailModule = assemblyModuleBuilder?.makeDetailMoviesModule(
            id: Constants.testIDString
        )
        XCTAssertTrue(movieDetailModule is MovieDetailViewController)
    }

    func testMakeFavoriteModule() {
        let favoriteMoviesModule = assemblyModuleBuilder?.makeFavoriteMoviesModule()
        XCTAssertTrue(favoriteMoviesModule is FavoriteViewController)
    }
}
