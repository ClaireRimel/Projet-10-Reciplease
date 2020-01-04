//
//  RecipesListModel.swift
//  Reciplease
//
//  Created by Claire on 02/01/2020.
//  Copyright © 2020 Claire Sivadier. All rights reserved.
//

import Foundation

final class RecipesListModel {
    
    let recipes: [Recipe]
    
    init(recipes: [Recipe]) {
        self.recipes = recipes
    }
    
    func getRecipe(indexPath: IndexPath) -> Recipe {
        return recipes[indexPath.row]
    }
    
    func numberOfRecipes() -> Int {
           return recipes.count
       }
}
