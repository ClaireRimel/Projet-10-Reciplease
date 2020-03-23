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
    var deleteResult: Result<Void, Error> = .success(())
    
    
    func addToFavorite(recipe: Recipe) -> Result<NSManagedObject, Error> {
        addToFavoriteWasCalled = true
        return addToFavoriteResult
    }
    
    func delete(recipe: Recipe) -> Result<Void, Error> {
        self.recipeToDelete = recipe
        return deleteResult
    }
    
    func checkFavStatus(recipe: Recipe) -> Result<Bool, Error> {
        self.recipe = recipe
        return checkFavStatusResult
    }
}
