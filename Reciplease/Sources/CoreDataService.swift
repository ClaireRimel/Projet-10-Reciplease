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
    
    private func recoveredIngredientLines(object: NSManagedObject) -> [String] {
        let ingredientsLines = object.value(forKey: "ingredientLines") as? Data
        return try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(ingredientsLines!) as! [String]
    }
}

extension CoreDataService: FavoriteFetchable {
    
    func fetchRecipes() -> Result<[Recipe], Error> {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Missing AppDelegate reference")
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "RecipeEntity")
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            print("Fetch Result")
            print(result)
            let recipes = result.map {
                Recipe(label: $0.value(forKey: "label") as? String ?? "",
                       image: $0.value(forKey: "image") as? String ?? "",
                       url: $0.value(forKey: "url") as? String ?? "",
                       ingredientLines: recoveredIngredientLines(object: $0),
                       totalTime: $0.value(forKey: "totalTime") as? Int ?? 0)
            }
            
            print("Fetch Result - RECIPES")
            print(recipes)
            return .success(recipes)
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return .failure(error)
        }
    }
}

extension CoreDataService: FavoriteManageable {
    
    func addToFavorite(recipe: Recipe) -> Result<NSManagedObject, Error> {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Missing AppDelegate reference")
            
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "RecipeEntity", in: managedContext)!
        let recipeEntity = NSManagedObject(entity: entity, insertInto: managedContext)
        let ingredientLinesData = try! NSKeyedArchiver.archivedData(withRootObject: recipe.ingredientLines,
                                                                    requiringSecureCoding: true)
        
        recipeEntity.setValue(recipe.image, forKey: "image")
        recipeEntity.setValue(ingredientLinesData, forKey: "ingredientLines")
        recipeEntity.setValue(recipe.label, forKey: "label")
        recipeEntity.setValue(recipe.url, forKey: "url")
        
        
        do {
            try managedContext.save()
            print("RECIPES Has been added ")
            return .success(recipeEntity)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return .failure(error)
        }
    }
    
    func delete(recipe: Recipe) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Missing AppDelegate reference")
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
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
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func checkFavStatus(recipe: Recipe) -> Result<Bool, Error> {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Missing AppDelegate reference")
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
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
