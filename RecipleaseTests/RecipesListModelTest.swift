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
    var imageDownloadableMock: ImageDownloadableMock!
    var delegateMock: RecipesListModelDelegateMock!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        favoriteFetchableMock = FavoriteFetchableMock()
        imageDownloadableMock = ImageDownloadableMock()
        delegateMock = RecipesListModelDelegateMock()
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
    
    func testFetchRecipeSuccess() {
        //Given
        let recipe = Recipe(label: "Egg Fries", image: "", url: "", ingredientLines: [""])
        favoriteFetchableMock.response = .success([recipe])
        sut = RecipesListModel(source: .search([]), coreDataService: favoriteFetchableMock)
        sut.delegate = delegateMock
        XCTAssertFalse(delegateMock.reloadDataWasCalled)
        
        //When
        sut.fetchRecipes()
        
        //Then
        XCTAssertEqual(sut.recipes, [recipe])
        XCTAssert(delegateMock.reloadDataWasCalled)
    }
    
    func testFetchRecipeError() {
        //Given
        let error = NSError(domain: "", code: 0, userInfo: nil)
        favoriteFetchableMock.response = .failure(error)
        sut = RecipesListModel(source: .search([]), coreDataService: favoriteFetchableMock)
        sut.delegate = delegateMock
        XCTAssertNil(delegateMock.error)
        
        //When
        sut.fetchRecipes()
        
        //Then
        XCTAssertEqual(sut.recipes, [])
        XCTAssertNotNil(delegateMock.error)
    }
    
    func testGetRecipe() {
        //Given
        let indexPath = IndexPath(row: 0, section: 0)
        let recipe = Recipe(label: "Egg Fries", image: "", url: "", ingredientLines: [""])
        sut = RecipesListModel(source: .search([recipe]))
        
        //When
        let result = sut.getRecipe(for: indexPath)
        
        //Then
        XCTAssertEqual(result, recipe)
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
    
    func testUsesRecipeImagePropertyAsURLToDownloadImage() {
        //Given
        let indexPath = IndexPath(row: 0, section: 0)
        let recipe = Recipe(label: "Egg Fries", image: "https://www.edamam.com/web-img/e42/e42f9119813e890af34c259785ae1cfb.jpg", url: "", ingredientLines: [""])
        sut = RecipesListModel(source: .search([recipe]), imageDownloadable: imageDownloadableMock)
        
        //When
        sut.requestImage(for: indexPath, then: { _ in })
        
        //Then
        XCTAssertEqual(imageDownloadableMock.url, recipe.image)
    }
        
    func testImageServiceFails() {
        //Given
        let testexpetation = expectation(description: "")
        let indexPath = IndexPath(row: 0, section: 0)
        let recipe = Recipe(label: "Egg Fries", image: "https://www.edamam.com/web-img/e42/e42f9119813e890af34c259785ae1cfb.jpg", url: "", ingredientLines: [""])
        sut = RecipesListModel(source: .search([recipe]), imageDownloadable: imageDownloadableMock)
        
        let error = NSError(domain: "", code: 0, userInfo: nil)
        imageDownloadableMock.result = .failure(error)
        
        //When
        sut.requestImage(for: indexPath, then: { result in
            
            //Then
            if case let .failure(resultError as NSError) = result {
                XCTAssertEqual(resultError, error)
                testexpetation.fulfill()
            }
        })
        wait(for: [testexpetation], timeout: 1)
    }
    
    func testImageServiceSuccess() {
        //Given
        let testexpetation = expectation(description: "")
        let indexPath = IndexPath(row: 0, section: 0)
        let recipe = Recipe(label: "Egg Fries", image: "https://www.edamam.com/web-img/e42/e42f9119813e890af34c259785ae1cfb.jpg", url: "", ingredientLines: [""])
        sut = RecipesListModel(source: .search([recipe]), imageDownloadable: imageDownloadableMock)
        
        let image = UIImage()
        imageDownloadableMock.result = .success(image)
        
        //When
        sut.requestImage(for: indexPath, then: { result in
            
            //Then
            if case let .success(resultImage) = result {
                XCTAssertEqual(resultImage, image)
                testexpetation.fulfill()
            }
        })
        wait(for: [testexpetation], timeout: 1)
    }
    
    func testFetchRecipesOnViewWillAppear() {
        //Given
        sut = RecipesListModel(source: .favorite, coreDataService: favoriteFetchableMock)
        
        //When
        sut.viewWillAppear()
        
        //Then
        XCTAssert(favoriteFetchableMock.fetchRecipesWasCalled)
    }
    
    func testDoesNotFetchRecipesOnViewWillAppear() {
        //Given
        sut = RecipesListModel(source: .search([]), coreDataService: favoriteFetchableMock)
        
        //When
        sut.viewWillAppear()
        
        //Then
        XCTAssertFalse(favoriteFetchableMock.fetchRecipesWasCalled)
    }
}
