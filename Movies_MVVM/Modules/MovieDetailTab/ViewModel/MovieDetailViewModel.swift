// MovieDetailViewModel.swift
// Copyright © Aleksandr Dorofeev. All rights reserved.

import Foundation

/// Movie detail view model
final class MovieDetailViewModel: MovieDetailViewModelProtocol {
    // MARK: - Private Constants

    private enum Constants {
        static let emptyString = ""
    }

    // MARK: - Public properties

    var successDetailHandler: VoidHandler?
    var failureDetailHandler: ErrorHandler?
    var successActorsHandler: VoidHandler?
    var failureActorsHandler: ErrorHandler?
    var backHandler: VoidHandler?

    // MARK: - Private properties

    private let dataService: DataServiceProtocol

    private(set) var id: String?
    private(set) var movieDetail: MovieDetail?
    private(set) var cast: [Cast] = []
    private(set) var imageService: ImageServiceProtocol
    private(set) var networkService: NetworkServiceProtocol

    // MARK: - Initializer

    init(
        networkService: NetworkServiceProtocol,
        imageService: ImageServiceProtocol,
        id: String?,
        dataService: DataServiceProtocol
    ) {
        self.networkService = networkService
        self.imageService = imageService
        self.id = id
        self.dataService = dataService
        getMovieDetails()
    }

    // MARK: - Public methods

    func backPreviousScreen() {
        backHandler?()
    }

    func fetchCast(components: String) {
        networkService.fetchCast(id: components) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(cast):
                guard
                    let cast = cast?.cast,
                    !cast.isEmpty
                else {
                    self.successActorsHandler?()
                    return
                }
                self.cast += cast
                self.successActorsHandler?()
            case let .failure(error):
                self.failureActorsHandler?(error)
            }
        }
    }

    // MARK: - Private methods

    private func getMovieDetails() {
        guard
            let id = id,
            let intId = Int(id),
            let movieDetail = dataService.readMovieDetailData(id: intId)
        else {
            return fetchMovieDetails()
        }
        self.movieDetail = movieDetail
        successDetailHandler?()
    }

    private func fetchMovieDetails() {
        guard
            let id = id,
            let idInt = Int(id)
        else { return }
        networkService.fetchDetails(id: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(movieDetail):
                self.movieDetail = movieDetail
                self.dataService.writeMovieDetailData(movieDetail: movieDetail, id: idInt)
                self.successDetailHandler?()
            case let .failure(error):
                self.failureDetailHandler?(error)
            }
        }
    }
}
