// MovieData+CoreDataProperties.swift
// Copyright © Aleksandr Dorofeev. All rights reserved.

import CoreData
import Foundation

/// Movie data in core data
public extension MovieData {
    // MARK: - Private Constants

    private enum Constants {
        static let entityName = "MovieData"
    }

    // MARK: - Public properties

    @NSManaged var id: Int64
    @NSManaged var movieType: String?
    @NSManaged var posterPath: String?
    @NSManaged var title: String?
    @NSManaged var voteAverage: Double

    // MARK: - Public methods

    @nonobjc class func fetchRequest() -> NSFetchRequest<MovieData> {
        NSFetchRequest<MovieData>(entityName: Constants.entityName)
    }
}
