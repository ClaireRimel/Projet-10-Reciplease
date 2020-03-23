//
//  CoreDataStackTest.swift
//  RecipleaseTests
//
//  Created by Claire on 23/03/2020.
//  Copyright © 2020 Claire Sivadier. All rights reserved.
//

import Foundation
import CoreData
@testable import Reciplease

class TestCoreDataStack: CoreDataStack {

    override init(modelName: String) {
        super.init(modelName: modelName)

        let description =
            NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false

        let container = NSPersistentContainer(name: modelName)
        container.persistentStoreDescriptions =
            [description]

        container.loadPersistentStores {
            (storeDescription, error) in
            if let error = error as NSError? {
                fatalError(
                    "Unresolved error \(error), \(error.userInfo)")
            }
        }

        self.persistentContainer = container
    }
}
