// GenreData+CoreDataProperties.swift
// Copyright © Aleksandr Dorofeev. All rights reserved.

import CoreData
import Foundation

/// Genre data in core data
extension GenreData {
    // MARK: - Private Constants

    private enum Constants {
        static let entityName = "GenreData"
    }

    // MARK: - Public properties

    /// Name
    @NSManaged var name: String?
    /// Movie detail parent
    @NSManaged var movieDetail: MovieDetailData?

    // MARK: - Public methods

    @nonobjc class func fetchRequest() -> NSFetchRequest<GenreData> {
        NSFetchRequest<GenreData>(entityName: Constants.entityName)
    }
}
