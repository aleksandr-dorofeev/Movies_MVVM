// MockKeychainService.swift
// Copyright © Aleksandr Dorofeev. All rights reserved.

import Foundation

@testable import Movies_MVVM

/// Mock keychain service
final class MockKeychainService: KeychainServiceProtocol {
    // MARK: - Private Constants

    private enum Constants {
        static let mockKeyName = "mockKey"
    }

    // MARK: - Public properties

    var keyValue: String?

    // MARK: - Public methods

    func writeKey(text: String) {
        keyValue = text
    }

    func readKey() -> String? {
        Constants.mockKeyName
    }
}
