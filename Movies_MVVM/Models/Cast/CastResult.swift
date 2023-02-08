// CastResult.swift
// Copyright © Aleksandr Dorofeev. All rights reserved.

import Foundation

/// CastResult model.
struct CastResult: Decodable {
    /// Film ID
    let id: Int
    /// Cast results
    let cast: [Cast]
}
