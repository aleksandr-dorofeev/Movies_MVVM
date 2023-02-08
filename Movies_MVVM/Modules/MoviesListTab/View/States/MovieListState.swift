// MovieListState.swift
// Copyright © Aleksandr Dorofeev. All rights reserved.

import Foundation

/// Movie list screen states
enum MovieListState {
    case initial
    case success
    case failure(Error)
}
