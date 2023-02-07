// ImageServiceProtocol.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Protocol for image service
protocol ImageServiceProtocol {
    func getImage(imagePath: String, completion: @escaping (Result<Data?, Error>) -> ())
}
