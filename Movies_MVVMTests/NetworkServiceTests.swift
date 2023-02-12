// NetworkServiceTests.swift
// Copyright © Aleksandr Dorofeev. All rights reserved.

import XCTest

@testable import Movies_MVVM

/// Network service tests
final class NetworkServiceTests: XCTestCase {
    // MARK: - Private Constants

    private enum Constants {
        static let categoryOfMoviesName = "popular"
        static let numberPage = 1
        static let movieDetailIDString = "550"
        static let movieCastIDString = "411"
        static let amountMovies = 1
        static let amountActors = 6
        static let mockGenres = [MovieDetail.Genres(name: "Drama")]
        static let moviePosterPath = "/e1mjopzAS2KNsvpbpahQ1a6SkSn.jpg"
        static let movieTitle = "Suicide Squad"
        static let castName = "Skandar Keynes"
        static let castCharacter = "Edmund Pevensie"
        static let castProfilePath = "/pIdgY16c6AzmCD31pXlCR9SjLlM.jpg"
        static let emptyString = ""
        static let movieDetailTitle = "Fight Club"
        static let movieDetailReleaseDateString = "1999-10-12"
    }

    // MARK: - Private properties

    private let mockMovie = [
        Movie(
            id: 297_761,
            posterPath: Constants.moviePosterPath,
            title: Constants.movieTitle,
            voteAverage: 5.91
        )
    ]
    private let mockCast = [
        Cast(
            name: Constants.castName,
            character: Constants.castCharacter,
            profilePath: Constants.castProfilePath
        )
    ]
    private let mockMovieDetail = MovieDetail(
        posterPath: Constants.emptyString,
        title: Constants.movieDetailTitle,
        voteAverage: 7.8,
        releaseDate: Constants.movieDetailReleaseDateString,
        genres: Constants.mockGenres,
        overview: Constants.emptyString,
        id: 550
    )
    private var networkServiceCore = NetworkServiceCore()
    private var networkService: NetworkServiceProtocol?
    private var movieResults: MovieResults?
    private var movieDetail: MovieDetail?
    private var castResult: CastResult?

    // MARK: - Public methods

    override func setUp() {
        networkService = MockNetworkService()
    }

    override func tearDown() {
        networkService = nil
    }

    func testSuccessMovies() {
        movieResults = MovieResults(results: mockMovie)
        networkServiceCore = NetworkServiceCore()
        networkService = MockNetworkService(networkServiceCore: networkServiceCore, movieResults: movieResults)
        var catchMovies: [Movie]?
        networkService?
            .fetchMovies(categoryOfMovies: Constants.categoryOfMoviesName, page: Constants.numberPage) { result in
                switch result {
                case let .success(movies):
                    catchMovies = movies?.results
                case .failure:
                    break
                }
            }
        XCTAssertEqual(catchMovies?.count, Constants.amountMovies)
        movieResults = nil
    }

    func testFailureMovies() {
        networkService = MockNetworkService(networkServiceCore: nil, movieResults: movieResults)
        var catchError: Error?
        networkService?
            .fetchMovies(categoryOfMovies: Constants.categoryOfMoviesName, page: Constants.numberPage) { result in
                switch result {
                case .success:
                    break
                case let .failure(error):
                    catchError = error
                }
            }
        XCTAssertNotNil(catchError)
    }

    func testSuccessMovieDetail() {
        movieDetail = mockMovieDetail
        networkServiceCore = NetworkServiceCore()
        networkService = MockNetworkService(networkServiceCore: networkServiceCore, movieDetail: movieDetail)
        let movieID = Constants.movieDetailIDString
        var catchMovieDetail: MovieDetail?
        networkService?.fetchDetails(id: movieID) { result in
            switch result {
            case let .success(movieDetail):
                catchMovieDetail = movieDetail
            case .failure:
                break
            }
        }
        XCTAssertNotNil(catchMovieDetail?.title)
        movieDetail = nil
    }

    func testFailureMovieDetail() {
        networkService = MockNetworkService(networkServiceCore: nil, movieDetail: movieDetail)
        let movieID = Constants.movieDetailIDString
        var catchError: Error?
        networkService?.fetchDetails(id: movieID) { result in
            switch result {
            case .success:
                break
            case let .failure(error):
                catchError = error
            }
        }
        XCTAssertNotNil(catchError)
    }

    func testSuccessCast() {
        castResult = CastResult(id: 411, cast: mockCast)
        networkServiceCore = NetworkServiceCore()
        networkService = MockNetworkService(networkServiceCore: networkServiceCore, castResult: castResult)
        var catchCast: [Cast]?
        let movieID = Constants.movieCastIDString

        networkService?.fetchCast(id: movieID) { result in
            switch result {
            case let .success(cast):
                catchCast = cast?.cast
            case .failure:
                break
            }
        }
        XCTAssertEqual(catchCast?.count, Constants.amountActors)
        castResult = nil
    }

    func testFailureCast() {
        networkService = MockNetworkService(networkServiceCore: nil, castResult: nil)
        let movieID = Constants.movieCastIDString
        var catchError: Error?
        networkService?.fetchCast(id: movieID) { result in
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
