//
//  RecipeDetailsModelTests.swift
//  RecipleaseTests
//
//  Created by Claire on 08/03/2020.
//  Copyright © 2020 Claire Sivadier. All rights reserved.
//
import XCTest
import CoreData
@testable import Reciplease

class RecipeDetailsModelTests: XCTestCase {
    
    var sut: RecipeDetailsModel!
    var imageDownloadableMock: ImageDownloadableMock!
    var favoriteManageableMock: FavoriteManageableMock!
    var delegateMock: ErrorMessageDisplayableMock!
    
    
    override func setUp() {
        imageDownloadableMock = ImageDownloadableMock()
        favoriteManageableMock = FavoriteManageableMock()
        delegateMock = ErrorMessageDisplayableMock()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGetFirstIngredient() {
        //Given
        let recipe = Recipe(label: "Egg Fries", image: "", url: "", ingredientLines: ["1", "2", "3"], totalTime: 1)
        sut = RecipeDetailsModel(recipe: recipe)
        
        //When
        let indexPath = IndexPath(row: 0, section: 0)
        let result = sut.getDetails(for: indexPath)
        
        //Then
        XCTAssertEqual(result, "1")
    }
    
    func testNumberOfIngredients() {
        //Given
        let recipe = Recipe(label: "Egg Fries", image: "", url: "", ingredientLines: ["1", "2", "3"], totalTime: 1)
        sut = RecipeDetailsModel(recipe: recipe)
        
        //When
        let result = sut.numberOfIngredients()
        //Then
        
        XCTAssertEqual(result, 3)
    }
    
    func testGetURL() {
        //Given
        let recipe = Recipe(label: "Egg Fries", image: "", url: "http://www.seriouseats.com/recipes/2011/12/chicken-vesuvio-recipe.html", ingredientLines: [], totalTime: 1)
        sut = RecipeDetailsModel(recipe: recipe)
        
        //When
        let result = sut.getURL()
        
        //Then
        XCTAssertEqual(result?.absoluteString, recipe.url)
    }
    
    func testRequestImageSuccess() {
        //Given
        let testexpetation = expectation(description: "")
        let recipe = Recipe(label: "Egg Fries", image: "https://www.edamam.com/web-img/e42/e42f9119813e890af34c259785ae1cfb.jpg", url: "", ingredientLines: [""], totalTime: 1)
        sut = RecipeDetailsModel(recipe: recipe, imageDownloadable: imageDownloadableMock)
        
        let image = UIImage()
        imageDownloadableMock.result = .success(image)
        
        //When
        sut.requestImage(then: { result in
            
            //Then
            if case let .success(resultImage) = result {
                XCTAssertEqual(resultImage, image)
                testexpetation.fulfill()
            }
        })
        wait(for: [testexpetation], timeout: 1)
    }
    
    func testRequestImageFails() {
        //Given
        let testexpetation = expectation(description: "")
        let recipe = Recipe(label: "Egg Fries", image: "https://www.edamam.com/web-img/e42/e42f9119813e890af34c259785ae1cfb.jpg", url: "", ingredientLines: [""], totalTime: 1)
        sut = RecipeDetailsModel(recipe: recipe, imageDownloadable: imageDownloadableMock)
        
        let error = NSError(domain: "", code: 0, userInfo: nil)
        imageDownloadableMock.result = .failure(error)
        
        //When
        sut.requestImage(then: { result in
            
            //Then
            if case let .failure(resultError as NSError) = result {
                XCTAssertEqual(resultError, error)
                testexpetation.fulfill()
            }
        })
        wait(for: [testexpetation], timeout: 1)
    }
    
    func testAddToFavoriteSuccess() {
        //Given
        let recipe = Recipe(label: "Egg Fries", image: "", url: "", ingredientLines: [""], totalTime: 1)
        let objet = NSManagedObject()
        favoriteManageableMock.addToFavoriteResult = .success(objet)
        sut = RecipeDetailsModel(recipe: recipe, coreDataService: favoriteManageableMock)
        XCTAssertFalse(favoriteManageableMock.addToFavoriteWasCalled)
        
        //When
        sut.addToFavorite()
        
        //Then
        XCTAssert(favoriteManageableMock.addToFavoriteWasCalled)
    }
    
    func testAddToFavoriteError() {
        //Given
        let recipe = Recipe(label: "Egg Fries", image: "", url: "", ingredientLines: [""], totalTime: 1)
        let error = NSError(domain: "", code: 0, userInfo: nil)
        favoriteManageableMock.addToFavoriteResult = .failure(error)
        sut = RecipeDetailsModel(recipe: recipe, coreDataService: favoriteManageableMock)
        sut.delegate = delegateMock
        XCTAssertNil(delegateMock.error)

        //When
        sut.addToFavorite()

        //Then
        XCTAssertNotNil(delegateMock.error)
    }
    
    func testDelete() {
        //Given
        let recipe = Recipe(label: "Egg Fries", image: "", url: "", ingredientLines: [""], totalTime: 1)
        sut = RecipeDetailsModel(recipe: recipe,  coreDataService: favoriteManageableMock)
        
        //When
        sut.delete()
        
        //Then
        XCTAssertEqual(favoriteManageableMock.recipeToDelete, recipe)
    }
    
    func testCheckFavStatusIsFavorite() {
        //Given
        let recipe = Recipe(label: "Egg Fries", image: "", url: "", ingredientLines: [""], totalTime: 1)
        favoriteManageableMock.checkFavStatusResult = .success(true)
        sut = RecipeDetailsModel(recipe: recipe, coreDataService: favoriteManageableMock)

        //When
       let result = sut.checkFavStatus()
        
        //Then
        XCTAssert(result)
    }
    
    func testCheckFavStatusIsNotFavorite() {
           //Given
           let recipe = Recipe(label: "Egg Fries", image: "", url: "", ingredientLines: [""], totalTime: 1)
           favoriteManageableMock.checkFavStatusResult = .success(false)
           sut = RecipeDetailsModel(recipe: recipe, coreDataService: favoriteManageableMock)

           //When
          let result = sut.checkFavStatus()
           
           //Then
           XCTAssertFalse(result)
       }
    
    func testCheckFavStatusError() {
        //Given
        let recipe = Recipe(label: "Egg Fries", image: "", url: "", ingredientLines: [""], totalTime: 1)
        let error = NSError(domain: "", code: 0, userInfo: nil)
        favoriteManageableMock.checkFavStatusResult = .failure(error)
        sut = RecipeDetailsModel(recipe: recipe, coreDataService: favoriteManageableMock)
        sut.delegate = delegateMock
        XCTAssertNil(delegateMock.error)
        
        //When
        let result = sut.checkFavStatus()
        
        //Then
        XCTAssertNotNil(delegateMock.error)
        XCTAssertFalse(result)
    }
}

//Given

//When

//Then
