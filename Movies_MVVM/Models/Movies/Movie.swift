// Movie.swift
// Copyright © Aleksandr Dorofeev. All rights reserved.

import Foundation

/// Movie model
struct Movie: Decodable {
    /// ID
    let id: Int
    /// Poster path
    let posterPath: String?
    /// Title
    let title: String
    /// Vote average
    let voteAverage: Double

    // MARK: - Private Coding keys

    private enum CodingKeys: String, CodingKey {
        case id, title
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
    }
}
