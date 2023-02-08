// AssemblyModuleBuilderProtocol.swift
// Copyright © Aleksandr Dorofeev. All rights reserved.

import UIKit

/// Screens builder protocol
protocol AssemblyModuleBuilderProtocol {
    func makeMovieListModule() -> UIViewController
    func makeDetailMoviesModule(id: String?) -> UIViewController
    func makeFavoriteMoviesModule() -> UIViewController
}
