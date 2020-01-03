//
//  SearchModel.swift
//  Reciplease
//
//  Created by Claire on 31/12/2019.
//  Copyright © 2019 Claire Sivadier. All rights reserved.
//

import Foundation
import Alamofire

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
        
        let ingredients = arrayIngredients.joined(separator: " ")
        
        let parameters = ["q": ingredients, "app_id": "a674e9c4", "app_key": "35f93780dbf6f834909870f2529a9871"]
        
        AF.request("https://api.edamam.com/search", method: .get, parameters: parameters).responseJSON { response in

            debugPrint(response)
            
// TODO: Missing errors handling 
                        
            guard let data = response.data,
                let responseJSON = try? JSONDecoder().decode(SearchRecipesResponse.self, from: data) else {
                    DispatchQueue.main.async {
                        then(.failure(.invalidResponseFormat))
                    }
                    return
            }
            // by using map, we create an array of recipe
            let recipes = responseJSON.hits.map({ $0.recipe })
            print(recipes)
            then(.success(recipes))
        }
    }
}
