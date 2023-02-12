// MovieData+CoreDataProperties.swift
// Copyright © Aleksandr Dorofeev. All rights reserved.

import CoreData
import Foundation

/// Movie data in core data
extension MovieData {
    // MARK: - Private Constants

    private enum Constants {
        static let entityName = "MovieData"
    }

    // MARK: - Public properties

    /// ID
    @NSManaged var id: Int64
    /// Movie type
    @NSManaged var movieType: String?
    /// Poster path
    @NSManaged var posterPath: String?
    /// Title
    @NSManaged var title: String?
    /// Vote average
    @NSManaged var voteAverage: Double

    // MARK: - Public methods

    @nonobjc class func fetchRequest() -> NSFetchRequest<MovieData> {
        NSFetchRequest<MovieData>(entityName: Constants.entityName)
    }
}
