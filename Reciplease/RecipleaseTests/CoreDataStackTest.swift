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
        //NSInMemoryStoreType allow use to do CoreData operation, while runnig units test
        //1. Doesn't modify the our data strored in production app
        //2. Independent production app states, provide a clean environment to run test on.
        //3. Ensures that all consequences of the CoreData instructions are discarded after each units test finishes
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
