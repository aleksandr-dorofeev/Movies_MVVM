// MovieListCoordinator.swift
// Copyright © Aleksandr Dorofeev. All rights reserved.

import UIKit

/// Coordinator for movie list
final class MovieListCoordinator: BaseCoordinator {
    // MARK: - Public visual components

    var rootViewController: UINavigationController?

    // MARK: - Public properties

    var assemblyModuleBuilder: AssemblyModuleBuilderProtocol?
    var onMovieDetailModule: IntVoidHandler?
    var onFinishFlowHandler: VoidHandler?

    // MARK: - Initializers

    convenience init(assemblyModuleBuilder: AssemblyModuleBuilderProtocol) {
        self.init()
        self.assemblyModuleBuilder = assemblyModuleBuilder
    }

    // MARK: - Public methods

    override func start() {
        showMovieListModule()
    }

    // MARK: - Private methods

    private func showMovieListModule() {
        guard
            let controller = assemblyModuleBuilder?.makeMovieListModule() as? MovieListViewController else { return }
        controller.viewModel?.onMovieDetailHandler = { [weak self] id in
            guard let self = self else { return }
            self.showMovieDetailModule(id: id)
        }
        let rootController = UINavigationController(rootViewController: controller)
        setAsRoot(rootController)
        rootViewController = rootController
    }

    private func showMovieDetailModule(id: String) {
        guard
            let controller = assemblyModuleBuilder?.makeDetailMoviesModule(id: id) as? MovieDetailViewController
        else { return }
        controller.viewModel?.backHandler = { [weak self] in
            guard let self = self else { return }
            self.popToRoot()
        }
        rootViewController?.pushViewController(controller, animated: true)
    }

    private func popToRoot() {
        rootViewController?.popToRootViewController(animated: true)
    }
}
