//
//  SearchModelTest.swift
//  RecipleaseTests
//
//  Created by Claire on 07/01/2020.
//  Copyright © 2020 Claire Sivadier. All rights reserved.
//

import XCTest
@testable import Reciplease

class SearchModelTest: XCTestCase {

    var sut: SearchModel!
    
    override func setUp() {
      sut = SearchModel()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAdd() {
        // given
        XCTAssertEqual(sut.numberOfIngredients(), 0)
        
        // when
        let ingredientToAdd = "Egg"
       sut.add(ingredient: ingredientToAdd)

        // then
        XCTAssertEqual(sut.numberOfIngredients(), 1)
        XCTAssertEqual(sut.getIngredient(for: IndexPath(row: 0, section: 0)), ingredientToAdd)
    }


    func testRemoveIngredients() {
        // given
        sut.add(ingredient: "Egg")
        XCTAssertEqual(sut.numberOfIngredients(), 1)
        
        // when
        sut.removeIngredients()
        
        // then
        XCTAssertEqual(sut.numberOfIngredients(), 0)
    }
    
    func testSearchRecipes() {
        // given
        let testExpectation = expectation(description: "")
        sut.add(ingredient: "Egg")

        // when
        sut.searchRecipes { (result) in
            // then
            
            //A -> array recipes

            testExpectation.fulfill()
        }

        //TODO: wait...
    }
    
    //B -> error
    
}
