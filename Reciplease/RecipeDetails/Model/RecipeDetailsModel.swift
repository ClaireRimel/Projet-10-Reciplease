//
//  RecipeDetailsModel.swift
//  Reciplease
//
//  Created by Claire on 02/01/2020.
//  Copyright © 2020 Claire Sivadier. All rights reserved.
//

import UIKit
import CoreData

final class RecipeDetailsModel {
    
    let recipe: Recipe
    var favorites: [NSManagedObject] = []
    let coreDataService: FavoriteManageable
    let imageDownloadable: ImageDownloadable
    weak var delegate: ErrorMessageDisplayable?
    
    init(recipe: Recipe,
         imageDownloadable: ImageDownloadable = ImageDownloadableService(),
         coreDataService: FavoriteManageable = CoreDataService()) {
        self.recipe = recipe
        self.imageDownloadable = imageDownloadable
        self.coreDataService = coreDataService
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
        imageDownloadable.requestImage(url: recipe.image, then: then)
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
        switch coreDataService.delete(recipe: recipe) {
        case let .failure(error):
            delegate?.show(error)
        default:
            break
        }
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
