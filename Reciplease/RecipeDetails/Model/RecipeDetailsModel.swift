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
        coreDataService.delete(recipe: recipe)
    }
    
    func checkFavStatus() -> Bool {
        switch coreDataService.checkFavStatus(recipe: recipe) {
        case let .success(isFavorite):
            return isFavorite
        case let .failure(error):
            delegate?.show(error)
            return false
        }
    }
}
