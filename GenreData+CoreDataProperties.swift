// GenreData+CoreDataProperties.swift
// Copyright © Aleksandr Dorofeev. All rights reserved.

import CoreData
import Foundation

/// Genre data in core data
public extension GenreData {
    // MARK: - Private Constants

    private enum Constants {
        static let entityName = "GenreData"
    }

    // MARK: - Public properties

    @NSManaged var name: String?
    @NSManaged var movieDetail: MovieDetailData?

    // MARK: - Public methods

    @nonobjc class func fetchRequest() -> NSFetchRequest<GenreData> {
        NSFetchRequest<GenreData>(entityName: Constants.entityName)
    }
}
