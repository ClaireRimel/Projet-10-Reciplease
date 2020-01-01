//
//  SearchModel.swift
//  Reciplease
//
//  Created by Claire on 31/12/2019.
//  Copyright © 2019 Claire Sivadier. All rights reserved.
//

import Foundation

// Only class can comforn to this protocol
protocol SearchModelDelegate: class {
    
    func searchModelDidAddIngredient(_ searchModel: SearchModel)
    func searchModelDidDeleteIngredients(_ searchModel: SearchModel)
}

class SearchModel {
    
    private var arrayIngredients: [String] = []
    weak var delegate: SearchModelDelegate?
    
    func addIngredient(text: String) {
        arrayIngredients.append(text)
        delegate?.searchModelDidAddIngredient(self)
    }
    
    func removeIngredients() {
        arrayIngredients.removeAll()
        delegate?.searchModelDidDeleteIngredients(self)
    }
    
    func numberOfIngredients() -> Int {
        return arrayIngredients.count
    }
    
    func getIngredient(indexPath: IndexPath) -> String {
        return arrayIngredients[indexPath.row]
    }
    
    func request(then: @escaping (Result<[Recipe], SearchRecipesError>) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.edamam.com"
        urlComponents.path = "/search"
        
        let ingredients = arrayIngredients.joined(separator: " ")

        urlComponents.queryItems = [URLQueryItem(name: "q", value: ingredients),
                                    URLQueryItem(name: "app_id", value: "a674e9c4"),
                                    URLQueryItem(name: "app_key", value: "35f93780dbf6f834909870f2529a9871")]
        
        guard let url = urlComponents.url else {
            fatalError("Invalid URL")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // Verifies if the request threw an error
            if let error = error as NSError? {
                DispatchQueue.main.async {
                    then(.failure(.requestError(error)))
                }
                return
            }

            guard let data = data,
                let responseJSON = try? JSONDecoder().decode(SearchRecipesResponse.self, from: data) else {
                    DispatchQueue.main.async {
                        then(.failure(.invalidResponseFormat))
                    }
                    return
            }
            
            print(responseJSON)
        }
        task.resume()
    }
}

struct SearchRecipesResponse: Codable {
    let hits: [RecipeHits]
}

struct RecipeHits: Codable {
    let recipe: Recipe
}

struct Recipe: Codable {
    let label: String
    let image: String
    let url: String
    let ingredientLines: [String]
    // temps de preparation et
}
