//
//  RecipesListModel.swift
//  Reciplease
//
//  Created by Claire on 02/01/2020.
//  Copyright © 2020 Claire Sivadier. All rights reserved.
//

import UIKit
import CoreData

class RecipesListModel {
    //name space
    enum Source {
        case search([Recipe])
        case favorite
    }
    
    var recipes: [Recipe] = []
    let source: Source
    let coreDataService: FavoriteFetchable
    let imageDownloadable: ImageDownloadable
    weak var delegate: RecipesListModelDelegate?

    //Dependency injection via initializer
    init(source: Source,
         coreDataService: FavoriteFetchable = CoreDataService(),
         imageDownloadable: ImageDownloadable = ImageDownloadableService()) {
        self.source = source
        self.coreDataService = coreDataService
        self.imageDownloadable = imageDownloadable
        switch source {
        case let .search(recipes):
            self.recipes = recipes
        case .favorite:
            self.fetchRecipes()
        }
    }

    func fetchRecipes() {
        switch coreDataService.fetchRecipes() {
        case let .success(recipes):
            self.recipes = recipes
            self.delegate?.reloadData()
        case let .failure(error):
            self.delegate?.show(error)
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
        imageDownloadable.requestImage(url: recipe.image, then: then)
    }
    
    func viewWillAppear() {
        // pattern matching
        if case .favorite = source {
            fetchRecipes()
        }
    }
}

protocol RecipesListModelDelegate: ErrorMessageDisplayable {
    func reloadData()
}

