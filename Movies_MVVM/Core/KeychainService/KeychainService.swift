// KeychainService.swift
// Copyright © Aleksandr Dorofeev. All rights reserved.

import Foundation
import KeychainSwift

/// Keychain service
final class KeychainService: KeychainServiceProtocol {
    // MARK: - Private Constants

    private enum Constants {
        static let key = "key"
    }

    // MARK: - Private properties

    private var keychain = KeychainSwift()

    // MARK: - Public methods

    func writeKey(text: String) {
        keychain.set(text, forKey: Constants.key)
    }

    func readKey() -> String? {
        keychain.get(Constants.key)
    }
}
