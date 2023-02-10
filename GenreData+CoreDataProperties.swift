// GenreData+CoreDataProperties.swift
// Copyright © Aleksandr Dorofeev. All rights reserved.

import CoreData
import Foundation

///
public extension GenreData {
    @nonobjc class func fetchRequest() -> NSFetchRequest<GenreData> {
        NSFetchRequest<GenreData>(entityName: "GenreData")
    }

    @NSManaged var name: String?
    @NSManaged var movieDetail: MovieDetailData?
}
