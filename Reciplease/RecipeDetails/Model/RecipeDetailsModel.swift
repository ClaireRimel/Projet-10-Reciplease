//
//  RecipeDetailsModel.swift
//  Reciplease
//
//  Created by Claire on 02/01/2020.
//  Copyright © 2020 Claire Sivadier. All rights reserved.
//

import UIKit
import CoreData

final class RecipeDetailsModel: ImageDownloadable {
    
    let recipe: Recipe
    var favorites: [NSManagedObject] = []
    
    init(recipe: Recipe) {
        self.recipe = recipe
    }
    
//    let favoriteRecipe = favorites.map{({ (url) -> String in
//        return
//    })}
//
    func getDetails(for indexPath: IndexPath) -> String {
        return recipe.ingredientLines[indexPath.row]
    }
    
    func numberOfIngredients() -> Int {
        return recipe.ingredientLines.count
    }
    
    func getURL() -> URL? {
        return URL(string: recipe.url)
    }
    
    func requestImage(then: @escaping (Result<UIImage, Error>) -> Void) {
        requestImage(url: recipe.image, then: then)
    }
    
    func addToFavorite() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "RecipeEntity", in: managedContext)!
        
        let recipeEntity = NSManagedObject(entity: entity, insertInto: managedContext)
        
        recipeEntity.setValue(recipe.image, forKey: "image")
        //Todo: [ingredients]
        recipeEntity.setValue(recipe.label, forKey: "label")
        recipeEntity.setValue(recipe.url, forKey: "url")
        
        
        do {
            try managedContext.save()
            favorites.append(recipeEntity)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        print("RECIPES Has been added ")
    }
    
    func fetchRecipes() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
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
                       //                       ingredientLines: $0.value(forKey: "ingredientLines"))
                    ingredientLines: [])
            }
            
            print("Fetch Result - RECIPES")
            print(recipes)
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func delete() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
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
    
    func checkFavStatus() -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "RecipeEntity")
        fetchRequest.predicate = NSPredicate(format: "url == %@", recipe.url)
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            
            if result.count == 1 {
                return true
            } else {
                return false
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return false
        }
    }
}
