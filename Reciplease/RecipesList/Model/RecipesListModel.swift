//
//  RecipesListModel.swift
//  Reciplease
//
//  Created by Claire on 02/01/2020.
//  Copyright © 2020 Claire Sivadier. All rights reserved.
//

import UIKit

final class RecipesListModel: ImageDownloadable {
    
    let recipes: [Recipe]
    
    init(recipes: [Recipe]) {
        self.recipes = recipes
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
}
