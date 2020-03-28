//
//  SearchError.swift
//  Reciplease
//
//  Created by Claire on 01/01/2020.
//  Copyright © 2020 Claire Sivadier. All rights reserved.
//

import Foundation

//Enumeration of the error cases
enum SearchError: Error, Equatable {
    case requestError(NSError)
    case invalidResponseFormat
    case emptyIngredientString
    case emptyIngredientArray
}

extension SearchError: LocalizedError {
    
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

