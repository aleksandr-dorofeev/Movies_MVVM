// DataServiceTests.swift
// Copyright © Aleksandr Dorofeev. All rights reserved.

import XCTest

@testable import Movies_MVVM

/// Data service tests
final class DataServiceTests: XCTestCase {
    // MARK: - Private Constants

    private enum Constants {
        static let emptyString = ""
        static let mockCategory = "mockCategory"
        static let fooData = "Foo"
        static let barData = "Bar"
        static let mockMovieId = 2
        static let mockMovieDetailId = 1
        static let mockGenres: [MovieDetail.Genres] = []
    }

    // MARK: - Private properties

    private var mockMovies: [Movie] = [
        Movie(
            id: Constants.mockMovieId,
            posterPath: Constants.barData,
            title: Constants.barData,
            voteAverage: 1
        )
    ]
    private var mockMovieDetail = MovieDetail(
        posterPath: Constants.fooData,
        title: Constants.fooData,
        voteAverage: 0,
        releaseDate: Constants.fooData,
        genres: Constants.mockGenres,
        overview: Constants.fooData,
        id: Constants.mockMovieDetailId
    )
    private var dataService: DataServiceProtocol?

    // MARK: - Public methods

    override func setUp() {
        dataService = DataService()
    }

    override func tearDown() {
        dataService = nil
    }

    func testWriteMovies() {
        XCTAssertNotNil(dataService?.writeMovieData(movies: mockMovies, category: Constants.mockCategory))
    }

    func testWriteMovieDetail() {
        XCTAssertNotNil(
            dataService?
                .writeMovieDetailData(movieDetail: mockMovieDetail, id: Constants.mockMovieDetailId)
        )
    }

    func testReadMovies() {
        let result = dataService?.readMovieData(category: Constants.mockCategory)
        XCTAssertNotNil(result)
        guard let result else { return }
        guard let movie = Array(result).first else { return }
        XCTAssertNotNil(movie)
        guard let mockMovie = mockMovies.first else { return }
        XCTAssertEqual(movie.title, mockMovie.title)
        XCTAssertEqual(movie.id, mockMovie.id)
        XCTAssertEqual(movie.voteAverage, mockMovie.voteAverage)
        XCTAssertEqual(movie.posterPath, mockMovie.posterPath)
    }

    func testReadMovieDetail() {
        let result = dataService?.readMovieDetailData(id: Constants.mockMovieDetailId)
        XCTAssertNotNil(result)
        guard let result else { return }
        XCTAssertNotNil(result)
        XCTAssertEqual(mockMovieDetail.title, result.title)
        XCTAssertEqual(mockMovieDetail.posterPath, result.posterPath)
        XCTAssertEqual(mockMovieDetail.voteAverage, result.voteAverage)
        XCTAssertEqual(mockMovieDetail.id, result.id)
        XCTAssertEqual(mockMovieDetail.releaseDate, result.releaseDate)
        XCTAssertEqual(mockMovieDetail.genres.count, result.genres.count)
    }
}
