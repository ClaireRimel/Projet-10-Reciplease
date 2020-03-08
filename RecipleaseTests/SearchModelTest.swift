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
    var networkServiceMock: NetworkServiceMock!
    
    override func setUp() {
        networkServiceMock = NetworkServiceMock()
        sut = SearchModel(networkService: networkServiceMock)
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
    
    func testRemoveIngredient() {
        // given
        let indexPath = IndexPath(row: 0, section: 0)
        sut.add(ingredient: "Egg")
        sut.add(ingredient: "Pasta")
        
        XCTAssertEqual(sut.numberOfIngredients(), 2)
        
        // when
        sut.removeIngredient(at: indexPath)
        
        // then
        XCTAssertEqual(sut.numberOfIngredients(), 1)
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
    
    func testInvalidResponse() throws {
        //Given
        let testExpectation = expectation(description: "")
        let bundle = Bundle(for: SearchModelTest.self)
        let path = bundle.path(forResource: "RecipeRequestInvalidFormat", ofType: "json")
        let data = try Data(contentsOf: URL(fileURLWithPath: path!), options: .mappedIfSafe)
        
        networkServiceMock.result = .success(data)
        
        //When
        sut.searchRecipes { (result) in
            
            //Then
            XCTAssertEqual(result, .failure(.invalidResponseFormat))
            testExpectation.fulfill()
        }
        wait(for: [testExpectation], timeout: 1)
    }
    
    func testSearchRecipesRequestError() {
        //Given
        let testExpectation = expectation(description: "")
        
        let error = NSError(domain: "", code: 0, userInfo: nil)
        networkServiceMock.result = .failure(error)
        
        //When
        sut.searchRecipes { (result) in
            //Then
            XCTAssertEqual(result, .failure(.requestError(error as NSError)))
            testExpectation.fulfill()
        }
        wait(for: [testExpectation], timeout: 1)
    }
    
    func testSearchRecipesRequestSuccess() throws {
        //Given
        let testExpectation = expectation(description: "")
        let bundle = Bundle(for: SearchModelTest.self)
        let path = bundle.path(forResource: "ResponseJSonForTest", ofType: "json")
        let data = try Data(contentsOf: URL(fileURLWithPath: path!), options: .mappedIfSafe)
        
        networkServiceMock.result = .success(data)
        
        //When
        sut.searchRecipes { (result) in
            
            //Then
            XCTAssertEqual(try? result.get().count, 10)
            testExpectation.fulfill()
        }
        wait(for: [testExpectation], timeout: 1)
    }
}
