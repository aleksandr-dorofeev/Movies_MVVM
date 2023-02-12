// MovieDetailData+CoreDataProperties.swift
// Copyright © Aleksandr Dorofeev. All rights reserved.

import CoreData
import Foundation

/// Movie Detail data in core data
extension MovieDetailData {
    // MARK: - Private Constants

    private enum Constants {
        static let entityName = "MovieDetailData"
    }

    // MARK: - Public properties

    /// ID
    @NSManaged var id: Int64
    /// Overview
    @NSManaged var overview: String?
    /// Poster path
    @NSManaged var posterPath: String?
    /// Release date
    @NSManaged var releaseDate: String?
    /// Title
    @NSManaged var title: String?
    /// Vote average
    @NSManaged var voteAverage: Double
    /// Genres child
    @NSManaged var genres: NSSet?

    // MARK: - Public methods

    @nonobjc class func fetchRequest() -> NSFetchRequest<MovieDetailData> {
        NSFetchRequest<MovieDetailData>(entityName: Constants.entityName)
    }
}

/// Generated accessors for genres
extension MovieDetailData {
    @objc(addGenresObject:)
    @NSManaged func addToGenres(_ value: GenreData)

    @objc(removeGenresObject:)
    @NSManaged func removeFromGenres(_ value: GenreData)

    @objc(addGenres:)
    @NSManaged func addToGenres(_ values: NSSet)

    @objc(removeGenres:)
    @NSManaged func removeFromGenres(_ values: NSSet)
}
