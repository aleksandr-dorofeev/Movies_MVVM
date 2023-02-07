// ProxyProtocol.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Proxy protocol
protocol ProxyProtocol {
    func getImage(imagePath: String, completion: @escaping (Result<Data, Error>) -> ())
}
