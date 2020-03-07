//
//  RecipesListModelTest.swift
//  RecipleaseTests
//
//  Created by Claire on 07/03/2020.
//  Copyright © 2020 Claire Sivadier. All rights reserved.
//

import XCTest
@testable import Reciplease

class RecipesListModelTest: XCTestCase {
    
    var sut: RecipesListModel!
    var favoriteFetchableMock: FavoriteFetchableMock!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        favoriteFetchableMock = FavoriteFetchableMock()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInitFromSearch() {
        //Given
        let recipe = Recipe(label: "Egg Fries", image: "", url: "", ingredientLines: [""])
        
        //When
        sut = RecipesListModel(source: .search([recipe]))
        
        //Then
        XCTAssertEqual(sut.recipes, [recipe])
    }
    
    func testInitFromFavorite() {
        //Given
        let recipe = Recipe(label: "Egg Fries", image: "", url: "", ingredientLines: [""])
        favoriteFetchableMock.response = .success([recipe])
        
        //When
        sut = RecipesListModel(source: .favorite, coreDataService: favoriteFetchableMock)
        
        //Then
        XCTAssertEqual(sut.recipes, [recipe])
    }
    
    func testNumberOfRecipes() {
        //Given
        let recipe = Recipe(label: "Egg Fries", image: "", url: "", ingredientLines: [""])
        sut = RecipesListModel(source: .search([recipe]))

        //When
        let result = sut.numberOfRecipes()
        
        //Then
        XCTAssertEqual(result, 1)
    }
    
}

final class FavoriteFetchableMock : FavoriteFetchable {
    
    var response: Result<[Recipe], Error> = .success([])
    
    func fetchRecipes() -> Result<[Recipe], Error> {
        return response
    }
}

//Given

//When

//Then
