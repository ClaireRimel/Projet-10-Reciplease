//
//  SearchRecipesError.swift
//  Reciplease
//
//  Created by Claire on 01/01/2020.
//  Copyright © 2020 Claire Sivadier. All rights reserved.
//

import Foundation

enum SearchRecipesError: Error, Equatable {
    case requestError(NSError)
    case invalidResponseFormat
    case emptyIngredientString
    case emptyIngredientArray
}

extension SearchRecipesError: LocalizedError {
    
    var errorDescription: String?  {
        switch self {
        case let .requestError(error):
            return error.localizedDescription
        case .invalidResponseFormat:
            return "The response format is invalid"
        case .emptyIngredientString:
            return "Please enter an ingredient"
        case .emptyIngredientArray:
            return "Please enter an ingredient"
        }
    }
}

