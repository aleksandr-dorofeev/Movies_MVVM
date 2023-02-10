// MovieData+CoreDataProperties.swift
// Copyright © Aleksandr Dorofeev. All rights reserved.

import CoreData
import Foundation

///
public extension MovieData {
    @nonobjc class func fetchRequest() -> NSFetchRequest<MovieData> {
        NSFetchRequest<MovieData>(entityName: "MovieData")
    }

    @NSManaged var id: Int64
    @NSManaged var movieType: String?
    @NSManaged var posterPath: String?
    @NSManaged var title: String?
    @NSManaged var voteAverage: Double
}
