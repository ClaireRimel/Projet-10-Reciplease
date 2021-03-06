//
//  CoreDataService.swift
//  Reciplease
//
//  Created by Claire on 07/02/2020.
//  Copyright © 2020 Claire Sivadier. All rights reserved.
//

import UIKit
import CoreData

//The final keyword doesn't allow us to do subclassing
final class CoreDataService {
    
    let coreDataStack: CoreDataStack

        //Using dependency injection via initializer allows us to
        //1. provide as a default argument the value we want to use in our production code
        //2. possibility to pass a different object as a parameter that can act as a mock for testing purposes
        init(coreDataStack: CoreDataStack = CoreDataStack.shared) {
            self.coreDataStack = coreDataStack
        }

    
    private func recoveredIngredientLines(object: NSManagedObject) -> [String] {
        let ingredientsLines = object.value(forKey: "ingredientLines") as? Data
        return try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(ingredientsLines!) as! [String]
    }
}

extension CoreDataService: FavoriteFetchable {
    
    func fetchRecipes() -> Result<[Recipe], Error> {
        let managedContext = coreDataStack.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "RecipeEntity")
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            print("Fetch Result")
            print(result)
            let recipes = result.map {
                //All Recipe properties are non-optional, so we can assume there will be data stored for each of its properties
                Recipe(label: $0.value(forKey: "label") as! String,
                       image: $0.value(forKey: "image") as! String,
                       url: $0.value(forKey: "url") as! String,
                       ingredientLines: recoveredIngredientLines(object: $0),
                       totalTime: $0.value(forKey: "totalTime") as! Int)
            }
            
            print("Fetch Result - RECIPES")
            print(recipes)
            return .success(recipes)
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return .failure(error)
        }
    }
    
    func addToFavorite(recipe: Recipe, keyedArchiver: NSKeyedArchiver.Type) -> Result<NSManagedObject, Error> {
        
        let managedContext = coreDataStack.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "RecipeEntity", in: managedContext)!
        
        let recipeEntity = NSManagedObject(entity: entity, insertInto: managedContext)
        
        do {
            let ingredientLinesData = try keyedArchiver.archivedData(withRootObject: recipe.ingredientLines,
                                                                       requiringSecureCoding: true)
            
            recipeEntity.setValue(recipe.image, forKey: "image")
            recipeEntity.setValue(ingredientLinesData, forKey: "ingredientLines")
            recipeEntity.setValue(recipe.label, forKey: "label")
            recipeEntity.setValue(recipe.url, forKey: "url")
            recipeEntity.setValue(recipe.totalTime, forKey: "totalTime")
            try managedContext.save()
            print("RECIPES Has been added ")
            return .success(recipeEntity)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return .failure(error)
        }
    }
}

extension CoreDataService: FavoriteManageable {
    
    func addToFavorite(recipe: Recipe) -> Result<NSManagedObject, Error> {
        return addToFavorite(recipe: recipe, keyedArchiver: NSKeyedArchiver.self)
    }
    
    func delete(recipe: Recipe) -> Result<Void, Error> {
        let managedContext = coreDataStack.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "RecipeEntity")
        fetchRequest.predicate = NSPredicate(format: "url == %@", recipe.url)
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            print("Fetch Result")
            print(result)
            
            if let objectToDelete = result.first {
                managedContext.delete(objectToDelete)
                try managedContext.save()
            }
            print("Has been deleted RECIPES")
            return .success(())
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return .failure(error)
        }
    }
    
    func checkFavStatus(recipe: Recipe) -> Result<Bool, Error> {
        let managedContext = coreDataStack.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "RecipeEntity")
        fetchRequest.predicate = NSPredicate(format: "url == %@", recipe.url)
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            return .success(result.count == 1)
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return .failure(error)
        }
    }
}
