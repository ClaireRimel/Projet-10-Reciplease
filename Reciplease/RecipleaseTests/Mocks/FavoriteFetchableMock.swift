//
//  FavoriteFetchableMock.swift
//  RecipleaseTests
//
//  Created by Claire on 08/03/2020.
//  Copyright © 2020 Claire Sivadier. All rights reserved.
//
@testable import Reciplease
import Foundation

final class FavoriteFetchableMock : FavoriteFetchable {
    
    var response: Result<[Recipe], Error> = .success([])
    var fetchRecipesWasCalled = false
    
    func fetchRecipes() -> Result<[Recipe], Error> {
        fetchRecipesWasCalled = true
        return response
    }
}
