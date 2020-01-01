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
}

extension SearchRecipesError {
    var message: String{
        switch self {
        case let .requestError(error):
            return error.localizedDescription
        case .invalidResponseFormat:
            return "Le format de réponse du serveur est invalide "
        }
    }
}
