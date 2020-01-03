//
//  SearchRecipesResponse.swift
//  Reciplease
//
//  Created by Claire on 02/01/2020.
//  Copyright © 2020 Claire Sivadier. All rights reserved.
//

import Foundation

struct SearchRecipesResponse: Codable {
    let hits: [RecipeHits]
}

struct RecipeHits: Codable {
    let recipe: Recipe
}

struct Recipe: Codable {
    let label: String
    let image: String
    let url: String
    var ingredientLines: [String]
    // temps de preparation et
}
