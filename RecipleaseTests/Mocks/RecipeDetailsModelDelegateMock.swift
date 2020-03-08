//
//  RecipeDetailsModelDelegateMock.swift
//  RecipleaseTests
//
//  Created by Claire on 08/03/2020.
//  Copyright © 2020 Claire Sivadier. All rights reserved.
//
@testable import Reciplease
import Foundation

final class RecipeDetailsModelDelegateMock: ErrorMessageDisplayable {
    var error: Error?
    
    func show(_ error: Error) {
        self.error = error
    }
}
