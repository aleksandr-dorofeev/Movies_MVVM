// MovieDetail.swift
// Copyright © Aleksandr Dorofeev. All rights reserved.

import Foundation

/// Model for detail information about film
struct MovieDetail: Decodable {
    /// Poster path
    let posterPath: String
    /// Title
    let title: String
    /// Vote average
    let voteAverage: Double
    /// Release date
    let releaseDate: String
    /// Genres
    let genres: [Genres]
    /// Overview
    let overview: String

    private enum CodingKeys: String, CodingKey {
        case title, genres, overview
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
    }
}

/// Extension with genres
extension MovieDetail {
    struct Genres: Decodable {
        /// Genre name
        let name: String
    }
}
