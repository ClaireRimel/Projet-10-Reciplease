//
//  CoreDataServiceTests.swift
//  RecipleaseTests
//
//  Created by Claire on 23/03/2020.
//  Copyright © 2020 Claire Sivadier. All rights reserved.
//
import XCTest
import CoreData
@testable import Reciplease

class CoreDataServiceTests: XCTestCase {
    
    var sut: CoreDataService!
    var testCoreDataStack: TestCoreDataStack!
    
    override func setUp() {
        testCoreDataStack = TestCoreDataStack(modelName: "Reciplease")
        sut = CoreDataService(coreDataStack: testCoreDataStack)
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFetchRecipesFailure() throws {
        //Given
        testCoreDataStack = TestCoreDataStack(modelName: "not existing data model file")
        sut = CoreDataService(coreDataStack: testCoreDataStack)
        
        //When
        let result = sut.fetchRecipes()
        
        //Then
        XCTAssertThrowsError(try result.get())
    }
    
    func testAddToFavorite() throws {
        //Given
        var fetchResult = try sut.fetchRecipes().get()
        XCTAssert(fetchResult.isEmpty)
        
        //When
        let recipe = Recipe(label: "label", image: "image", url: "url", ingredientLines: ["1", "2", "3"], totalTime: 10)
        let addResult = sut.addToFavorite(recipe: recipe)
        XCTAssertNoThrow(try addResult.get())
        
        //Then
        fetchResult = try sut.fetchRecipes().get()
        XCTAssertEqual(fetchResult.count, 1)
        XCTAssertEqual(fetchResult[0], recipe)
    }
    
    func testAddToFavoriteFailure() throws {
        //Given
        let recipe = Recipe(label: "label", image: "image", url: "url", ingredientLines: ["1", "2", "3"], totalTime: 10)
        
        //When
        let result = sut.addToFavorite(recipe: recipe, keyedArchiver: NSKeyedArchiverMock.self)
        
        //Then
        XCTAssertThrowsError(try result.get())
    }

    func testRemoveFromFavorites() throws {
        //Given
        try testAddToFavorite()
        
        //When
        let recipe = Recipe(label: "label", image: "image", url: "url", ingredientLines: ["1", "2", "3"], totalTime: 10)
        let deleteResult = sut.delete(recipe: recipe)
        XCTAssertNoThrow(try deleteResult.get())
        
        //Then
        let fetchResult = try sut.fetchRecipes().get()
        XCTAssert(fetchResult.isEmpty)
    }
    
    func testRemoveFromFavoriteFailure() throws {
        //Given
        testCoreDataStack = TestCoreDataStack(modelName: "not existing data model file")
        sut = CoreDataService(coreDataStack: testCoreDataStack)
        
        //When
        let recipe = Recipe(label: "label", image: "image", url: "url", ingredientLines: ["1", "2", "3"], totalTime: 10)
        let result = sut.delete(recipe: recipe)
        
        //Then
        XCTAssertThrowsError(try result.get())
    }
    
    func testCheckFavStatusIsTrue() throws {
        //Given
        try testAddToFavorite()
        
        //When
        let recipe = Recipe(label: "label", image: "image", url: "url", ingredientLines: ["1", "2", "3"], totalTime: 10)
        let result = sut.checkFavStatus(recipe: recipe)
        
        //Then
        XCTAssertTrue(try result.get())
    }
    
    func testCheckFavStatusIsFalse() throws {
        //Given
        let fetchResult = try sut.fetchRecipes().get()
        XCTAssert(fetchResult.isEmpty)
        
        //When
        let recipe = Recipe(label: "label", image: "image", url: "url", ingredientLines: ["1", "2", "3"], totalTime: 10)
        let result = sut.checkFavStatus(recipe: recipe)
        
        //Then
        XCTAssertFalse(try result.get())
    }
    
    func testCheckFavStatusFailure() throws {
        //Given
        testCoreDataStack = TestCoreDataStack(modelName: "not existing data model file")
        sut = CoreDataService(coreDataStack: testCoreDataStack)
        
        //When
        let recipe = Recipe(label: "label", image: "image", url: "url", ingredientLines: ["1", "2", "3"], totalTime: 10)
        let result = sut.checkFavStatus(recipe: recipe)
        
        //Then
        XCTAssertThrowsError(try result.get())
    }
}
