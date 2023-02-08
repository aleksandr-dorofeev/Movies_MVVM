// ImageNetworkService.swift
// Copyright © Aleksandr Dorofeev. All rights reserved.

import Foundation

/// Service for request to network for image
final class ImageNetworkService: ImageNetworkServiceProtocol {
    // MARK: - Private Constants

    private enum UrlComponent {
        static let posterPathImageUrl = "https://image.tmdb.org/t/p/w500"
    }

    // MARK: - Public methods

    func fetchImageData(imagePath: String, completion: @escaping (Result<Data, Error>) -> ()) {
        guard let imagePath = URL(string: "\(UrlComponent.posterPathImageUrl)\(imagePath)") else { return }
        let session = URLSession.shared
        session.dataTask(with: imagePath) { jsonData, _, error in
            guard let data = jsonData else { return }
            do {
                completion(.success(data))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
