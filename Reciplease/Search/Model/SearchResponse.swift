//
//  SearchResponse.swift
//  Reciplease
//
//  Created by Claire on 02/01/2020.
//  Copyright © 2020 Claire Sivadier. All rights reserved.
//

import Foundation

struct SearchResponse: Codable {
    let hits: [RecipeHits]
}

struct RecipeHits: Codable {
    let recipe: Recipe
}

struct Recipe: Codable, Equatable {
    let label: String
    let image: String
    let url: String
    var ingredientLines: [String]
    var totalTime: Int
}
