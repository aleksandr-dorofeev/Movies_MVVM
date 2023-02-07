// MovieDetailViewModelProtocol.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Protocol for movie detail view model
protocol MovieDetailViewModelProtocol {
    var successDetailHandler: (() -> ())? { get set }
    var failureDetailHandler: ((Error) -> ())? { get set }
    var successActorsHandler: (() -> ())? { get set }
    var failureActorsHandler: ((Error) -> ())? { get set }
    var backHandler: (() -> ())? { get set }

    var imageService: ImageServiceProtocol { get }
    var networkService: NetworkServiceProtocol { get }
    var id: String? { get }
    var movieDetail: MovieDetail? { get }
    var cast: [Cast] { get }

    func fetchCast(components: String)
    func backPreviousScreen()
}
