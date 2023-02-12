// MockNetworkService.swift
// Copyright © Aleksandr Dorofeev. All rights reserved.

import Foundation

@testable import Movies_MVVM

/// Mock network service
final class MockNetworkService: NetworkServiceProtocol {
    // MARK: - Public Constants

    enum JSONType: String {
        case movieJsonName = "MockMovie"
        case movieDetailJsonName = "MockMovieDetail"
        case castJsonName = "MockCast"
    }

    // MARK: - Private Constants

    private enum Constants {
        static let errorMessage = "error"
        static let extensionJsonName = "json"
        static let resultsName = "results"
        static let castName = "cast"
    }

    // MARK: - Private properties

    private var networkServiceCore: NetworkServiceCoreProtocol?
    private var movieResults: MovieResults?
    private var castResult: CastResult?
    private var movieDetail: MovieDetail?

    // MARK: - Initializer

    convenience init(networkServiceCore: NetworkServiceCoreProtocol?, movieResults: MovieResults?) {
        self.init()
        self.networkServiceCore = networkServiceCore
        self.movieResults = movieResults
    }

    convenience init(networkServiceCore: NetworkServiceCoreProtocol?, movieDetail: MovieDetail?) {
        self.init()
        self.networkServiceCore = networkServiceCore
        self.movieDetail = movieDetail
    }

    convenience init(networkServiceCore: NetworkServiceCoreProtocol?, castResult: CastResult?) {
        self.init()
        self.networkServiceCore = networkServiceCore
        self.castResult = castResult
    }

    // MARK: - Public methods

    func fetchMovies(
        categoryOfMovies: String?,
        page: Int,
        completion: @escaping (Result<MovieResults?, Error>) -> Void
    ) {
        if networkServiceCore != nil {
            guard
                let data = getMockData(name: JSONType.movieJsonName),
                let movieResultData = try? JSONDecoder().decode(MovieResults.self, from: data)
            else { return }
            movieResults = movieResultData
            completion(.success(movieResultData))
        } else {
            let error = NSError(domain: Constants.errorMessage, code: 0)
            completion(.failure(error))
        }
    }

    func fetchCast(id: String, completion: @escaping (Result<CastResult?, Error>) -> Void) {
        if networkServiceCore != nil {
            guard
                let data = getMockData(name: JSONType.castJsonName),
                let castResultData = try? JSONDecoder().decode(CastResult.self, from: data)
            else { return }
            castResult = castResultData
            completion(.success(castResultData))
        } else {
            let error = NSError(domain: Constants.errorMessage, code: 0)
            completion(.failure(error))
        }
    }

    func fetchDetails(id: String, completion: @escaping (Result<MovieDetail, Error>) -> Void) {
        if networkServiceCore != nil {
            guard
                let data = getMockData(name: JSONType.movieDetailJsonName),
                let movieDetailData = try? JSONDecoder().decode(MovieDetail.self, from: data),
                var movieDetail = movieDetail
            else { return }
            movieDetail = movieDetailData
            completion(.success(movieDetail))
        } else {
            let error = NSError(domain: Constants.errorMessage, code: 0)
            completion(.failure(error))
        }
    }

    // MARK: - Private methods

    private func getMockData(name: JSONType, withExtension: String = Constants.extensionJsonName) -> Data? {
        guard let jsonURL = Bundle.main.path(forResource: name.rawValue, ofType: withExtension)
        else { return nil }
        do {
            let fileURL = URL(fileURLWithPath: jsonURL)
            let data = try Data(contentsOf: fileURL)
            return data
        } catch {
            print(Constants.errorMessage)
        }
        return nil
    }
}
