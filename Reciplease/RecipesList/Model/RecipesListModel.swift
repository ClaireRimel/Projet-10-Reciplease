//
//  RecipesListModel.swift
//  Reciplease
//
//  Created by Claire on 02/01/2020.
//  Copyright © 2020 Claire Sivadier. All rights reserved.
//

import UIKit
import CoreData

final class RecipesListModel: ImageDownloadable {
    //name space
    enum Source {
        case search([Recipe])
        case favorite
    }
    
    var recipes: [Recipe] = []
    let source: Source
    weak var delegate: RecipesListModelDelegate?
    
    init(source: Source) {
        self.source = source
        switch source {
        case let .search(recipes):
            self.recipes = recipes
        case .favorite:
            self.recipes = fetchRecipes()
        }
    }
    
    func recoveredIngredientLines(object: NSManagedObject) -> [String] {
        let ingredientsLines = object.value(forKey: "ingredientLines") as? Data
        return try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(ingredientsLines!) as! [String]
    }
    
    func fetchRecipes() -> [Recipe] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return []
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
                       ingredientLines: recoveredIngredientLines(object: $0))
            }
            
            print("Fetch Result - RECIPES")
            print(recipes)
            return recipes
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return []
        }
    }
    
    
    func getRecipe(for indexPath: IndexPath) -> Recipe {
        return recipes[indexPath.row]
    }
    
    func numberOfRecipes() -> Int {
           return recipes.count
       }
    
    func requestImage(for indexPath: IndexPath, then: @escaping (Result<UIImage, Error>) -> Void) {
        let recipe = recipes[indexPath.row]
        requestImage(url: recipe.image, then: then)
    }
    
    func viewWillAppear() {
        // pattern matching
        if case .favorite = source{
            self.recipes = fetchRecipes()
            delegate?.reloadData()
        }
    }
}

protocol RecipesListModelDelegate: class {
    func reloadData()
}
