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
    let coreDataService = CoreDataService()
    weak var delegate: ErrorMessageDisplayable?
    
    init(recipe: Recipe) {
        self.recipe = recipe
    }
    
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
        switch coreDataService.addToFavorite(recipe: recipe) {
        case let .success(recipeEntity):
            favorites.append(recipeEntity)
        case let .failure(error):
            delegate?.show(error)
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
            return result.count == 1
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return false
        }
    }
}
