// MovieDetailViewModelProtocol.swift
// Copyright © Aleksandr Dorofeev. All rights reserved.

import Foundation

/// Protocol for movie detail view model
protocol MovieDetailViewModelProtocol {
    var successDetailHandler: VoidHandler? { get set }
    var failureDetailHandler: ErrorHandler? { get set }
    var successActorsHandler: VoidHandler? { get set }
    var failureActorsHandler: ErrorHandler? { get set }
    var backHandler: VoidHandler? { get set }

    var networkService: NetworkServiceProtocol { get }
    var id: String? { get }
    var movieDetail: MovieDetail? { get }
    var cast: [Cast] { get }

    func fetchCast(components: String)
    func getPosterImage(posterPath: String, completion: @escaping (Data) -> ())
    func getActorImage(actorImagePath: String, completion: @escaping (Data) -> ())
    func backPreviousScreen()
}
