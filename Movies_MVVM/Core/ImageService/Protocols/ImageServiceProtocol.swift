// ImageServiceProtocol.swift
// Copyright © Aleksandr Dorofeev. All rights reserved.

import Foundation

/// Protocol for image service
protocol ImageServiceProtocol {
    func getImage(imagePath: String, completion: @escaping (Result<Data?, Error>) -> ())
}
