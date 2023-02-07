// CastResult.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// CastResult model.
struct CastResult: Decodable {
    /// Film ID
    let id: Int
    /// Cast results
    let cast: [Cast]
}
