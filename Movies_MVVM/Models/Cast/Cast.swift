// Cast.swift
// Copyright © Aleksandr Dorofeev. All rights reserved.

import Foundation

/// Cast model
struct Cast: Decodable {
    /// Name
    let name: String
    /// Character
    let character: String?
    /// Profile image path
    let profilePath: String?

    private enum CodingKeys: String, CodingKey {
        case name, character
        case profilePath = "profile_path"
    }
}
