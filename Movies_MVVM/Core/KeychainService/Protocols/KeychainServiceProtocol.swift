// KeychainServiceProtocol.swift
// Copyright © Aleksandr Dorofeev. All rights reserved.

import Foundation

/// Protocol for keychain
protocol KeychainServiceProtocol {
    func writeKey(text: String)
    func readKey() -> String?
}
