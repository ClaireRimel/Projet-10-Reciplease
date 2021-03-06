//
//  CoreDataStack.swift
//  Reciplease
//
//  Created by Claire on 23/03/2020.
//  Copyright © 2020 Claire Sivadier. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    //We'll use the singleton pattern to only have one instance of this class. Also it easies the access from SceneDelegate, to handle the app going to background event.
    static let shared = CoreDataStack(modelName: "Reciplease")
    
    private let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores {
            (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
}
