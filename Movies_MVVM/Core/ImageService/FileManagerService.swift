// FileManagerService.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Service for load data from cache
final class FileManagerService: FileManagerServiceProtocol {
    // MARK: - Private Constants

    private enum Constants {
        static let separatorCharacter: Character = "/"
        static let defaultNameString: Substring = "default"
        static let imagesDirectoryString = "images"
    }

    // MARK: - Private properties

    private var imagesMap: [String: Data] = [:]
    private lazy var fileManager = FileManager.default

    // MARK: - Public methods

    func getImageDataFromDisk(url: String) -> Data? {
        guard let filePath = getImagePath(url: url) else { return nil }
        let fileNameURL = URL(fileURLWithPath: filePath)
        do {
            let data = try Data(contentsOf: fileNameURL)
            imagesMap[url] = data
            return data
        } catch {}
        return nil
    }

    func saveImageToFile(url: String, data: Data) {
        guard let filePath = getImagePath(url: url) else { return }
        fileManager.createFile(atPath: filePath, contents: data)
    }

    // MARK: - Private methods

    private func getImagePath(url: String) -> String? {
        guard let folderUrl = cacheFolderPath() else { return nil }
        let fileName = url.split(separator: Constants.separatorCharacter).last ?? Constants.defaultNameString
        return folderUrl.appendingPathComponent(String(fileName)).path
    }

    private func cacheFolderPath() -> URL? {
        guard let docDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        else { return nil }
        let url = docDirectory.appendingPathComponent(Constants.imagesDirectoryString, isDirectory: true)
        if !fileManager.fileExists(atPath: url.path) {
            do {
                try fileManager.createDirectory(
                    at: url,
                    withIntermediateDirectories: true,
                    attributes: nil
                )
            } catch {
                print(error.localizedDescription)
            }
        }
        return url
    }
}
