//
//  RecipeDetailsModel.swift
//  Reciplease
//
//  Created by Claire on 02/01/2020.
//  Copyright © 2020 Claire Sivadier. All rights reserved.
//

import Foundation

class RecipeDetailsModel {
    
    let recipe: Recipe
    
    init(recipe: Recipe) {
        self.recipe = recipe
    }
    
    func getDetails(indexPath: IndexPath) -> String {
        return recipe.ingredientLines[indexPath.row]
    }
    
    func recipeInstruction() -> Int {
        return recipe.ingredientLines.count
    }
}
