// ApplicationCoordinator.swift
// Copyright © Aleksandr Dorofeev. All rights reserved.

import Foundation

/// App coordinator
final class ApplicationCoordinator: BaseCoordinator {
    // MARK: - Public properties

    var assemblyModuleBuilder: AssemblyModuleBuilderProtocol?

    // MARK: - Public methods

    override func start() {
        toMovieListModule()
    }

    // MARK: - Initialization

    convenience init(assemblyModuleBuilder: AssemblyModuleBuilderProtocol) {
        self.init()
        self.assemblyModuleBuilder = assemblyModuleBuilder
    }

    // MARK: - Private methods

    private func toMovieListModule() {
        guard let assemblyModuleBuilder = assemblyModuleBuilder else { return }
        let coordinator = MovieListCoordinator(assemblyModuleBuilder: assemblyModuleBuilder)
        coordinator.onFinishFlowHandler = { [weak self, weak coordinator] in
            guard let self = self else { return }
            self.removeDependency(coordinator)
            self.start()
        }
        addDependency(coordinator)
        coordinator.start()
    }
}
