// FileManagerServiceProtocol.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Loading and saving from cache protocol
protocol FileManagerServiceProtocol {
    func getImageDataFromDisk(url: String) -> Data?
    func saveImageToFile(url: String, data: Data)
}
