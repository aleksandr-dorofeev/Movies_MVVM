// DataCore.swift
// Copyright © Aleksandr Dorofeev. All rights reserved.

import CoreData
import Foundation

/// Data core
final class DataCore {
    // MARK: - Private Constants

    private enum Constants {
        static let movieContainerName = "MoviesContainer"
        static let unresolvedErrorString = "Unresolved error"
    }

    // MARK: - Public properties

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constants.movieContainerName)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("\(Constants.unresolvedErrorString) \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    // MARK: - Public methods

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("\(Constants.unresolvedErrorString) \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
