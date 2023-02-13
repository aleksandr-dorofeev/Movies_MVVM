// AssemblyModuleBuilder.swift
// Copyright © Aleksandr Dorofeev. All rights reserved.

import UIKit

/// Module builder
final class AssemblyModuleBuilder: AssemblyModuleBuilderProtocol {
    // MARK: - Public methods

    func makeMovieListModule() -> UIViewController {
        let view = MovieListViewController()
        let keychainService = KeychainService()
        let networkServiceCore = NetworkServiceCore(keychainService: keychainService)
        let networkService = NetworkService(networkServiceCore: networkServiceCore)
        let fileManagerService = FileManagerService()
        let imageNetworkService = ImageNetworkService()
        let proxyService = Proxy(imageNetworkService: imageNetworkService, fileManagerService: fileManagerService)
        let imageService = ImageService(proxy: proxyService)
        let dataService = DataService()
        let viewModel = MovieListViewModel(
            networkService: networkService,
            imageService: imageService,
            dataService: dataService,
            keychainService: keychainService
        )
        view.viewModel = viewModel
        return view
    }

    func makeDetailMoviesModule(id: String?) -> UIViewController {
        let view = MovieDetailViewController()
        let keychainService = KeychainService()
        let networkServiceCore = NetworkServiceCore(keychainService: keychainService)
        let networkService = NetworkService(networkServiceCore: networkServiceCore)
        let fileManagerService = FileManagerService()
        let imageNetworkService = ImageNetworkService()
        let proxyService = Proxy(imageNetworkService: imageNetworkService, fileManagerService: fileManagerService)
        let imageService = ImageService(proxy: proxyService)
        let dataService = DataService()
        let viewModel = MovieDetailViewModel(
            networkService: networkService,
            imageService: imageService,
            id: id,
            dataService: dataService
        )
        view.viewModel = viewModel
        return view
    }

    func makeFavoriteMoviesModule() -> UIViewController {
        let view = FavoriteViewController()
        return view
    }
}
