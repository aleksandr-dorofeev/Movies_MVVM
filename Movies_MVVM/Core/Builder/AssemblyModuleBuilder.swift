// AssemblyModuleBuilder.swift
// Copyright © Aleksandr Dorofeev. All rights reserved.

import UIKit

/// Module builder
final class AssemblyModuleBuilder: AssemblyModuleBuilderProtocol {
    // MARK: - Public methods

    func makeMovieListModule() -> UIViewController {
        let view = MovieListViewController()
        let networkService = NetworkService()
        let imageService = ImageService()
        let viewModel = MovieListViewModel(networkService: networkService, imageService: imageService)
        view.viewModel = viewModel
        return view
    }

    func makeDetailMoviesModule(id: String?) -> UIViewController {
        let view = MovieDetailViewController()
        let networkService = NetworkService()
        let imageService = ImageService()
        let viewModel = MovieDetailViewModel(networkService: networkService, imageService: imageService, id: id)
        view.viewModel = viewModel
        return view
    }

    func makeFavoriteMoviesModule() -> UIViewController {
        let view = FavoriteViewController()
        return view
    }
}
