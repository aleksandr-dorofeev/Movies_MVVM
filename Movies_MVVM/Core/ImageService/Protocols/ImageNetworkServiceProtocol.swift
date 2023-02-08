// ImageNetworkServiceProtocol.swift
// Copyright © Aleksandr Dorofeev. All rights reserved.

import Foundation

/// Fetching image data protocol
protocol ImageNetworkServiceProtocol {
    func fetchImageData(imagePath: String, completion: @escaping (Result<Data, Error>) -> ())
}
