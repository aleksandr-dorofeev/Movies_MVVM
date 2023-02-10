// MovieDetailData+CoreDataProperties.swift
// Copyright © Aleksandr Dorofeev. All rights reserved.

import CoreData
import Foundation

/// Movie Detail data in core data
public extension MovieDetailData {
    // MARK: - Private Constants

    private enum Constants {
        static let entityName = "MovieDetailData"
    }

    // MARK: - Public properties

    @NSManaged var id: Int64
    @NSManaged var overview: String?
    @NSManaged var posterPath: String?
    @NSManaged var releaseDate: String?
    @NSManaged var title: String?
    @NSManaged var voteAverage: Double
    @NSManaged var genres: NSSet?

    // MARK: - Public methods

    @nonobjc class func fetchRequest() -> NSFetchRequest<MovieDetailData> {
        NSFetchRequest<MovieDetailData>(entityName: Constants.entityName)
    }
}

/// Generated accessors for genres
public extension MovieDetailData {
    @objc(addGenresObject:)
    @NSManaged func addToGenres(_ value: GenreData)

    @objc(removeGenresObject:)
    @NSManaged func removeFromGenres(_ value: GenreData)

    @objc(addGenres:)
    @NSManaged func addToGenres(_ values: NSSet)

    @objc(removeGenres:)
    @NSManaged func removeFromGenres(_ values: NSSet)
}
