//
//  FavoriteManageableMock.swift
//  RecipleaseTests
//
//  Created by Claire on 08/03/2020.
//  Copyright © 2020 Claire Sivadier. All rights reserved.
//
@testable import Reciplease
import Foundation
import CoreData

final class FavoriteManageableMock: FavoriteManageable {
    
    var addToFavoriteResult: Result<NSManagedObject, Error> = .success(NSManagedObject())
    var addToFavoriteWasCalled = false
    var recipe: Recipe?
    var recipeToDelete: Recipe?
    var checkFavStatusResult: Result<Bool, Error> = .success(true)

    func addToFavorite(recipe: Recipe) -> Result<NSManagedObject, Error> {
        addToFavoriteWasCalled = true
        return addToFavoriteResult
    }
    
    func delete(recipe: Recipe) {
        self.recipeToDelete = recipe
    }
    
    func checkFavStatus(recipe: Recipe) -> Result<Bool, Error> {
        self.recipe = recipe
        return checkFavStatusResult
    }
}
