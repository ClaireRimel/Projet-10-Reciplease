//
//  SearchModel.swift
//  Reciplease
//
//  Created by Claire on 31/12/2019.
//  Copyright © 2019 Claire Sivadier. All rights reserved.
//

import Foundation
import Alamofire

final class SearchModel {
    
    private var ingredients: [String] = []
    
    let networkService: NetworkServiceInterface = NetworkService()
    
//    init(networkService: NetworkServiceInterface = NetworkService()) {
//        self.networkService = networkService
//    }
    
    func add(ingredient: String) {
        ingredients.append(ingredient)
    }
    
    func removeIngredient(at indexPath: IndexPath) {
        ingredients.remove(at: indexPath.row)
    }
    
    func removeIngredients() {
        ingredients.removeAll()
    }
    
    func numberOfIngredients() -> Int {
        return ingredients.count
    }
    
    func getIngredient(for indexPath: IndexPath) -> String {
        return ingredients[indexPath.row]
    }
    
    func searchRecipes(then: @escaping (Result<[Recipe], SearchRecipesError>) -> Void) {
        
        let string = ingredients.joined(separator: " ")
        
        let parameters = ["q": string,
                          "app_id": "a674e9c4",
                          "app_key": "35f93780dbf6f834909870f2529a9871"]
        //new code..
        networkService.request(parameters: parameters) { (result) in
            switch result {
            case let.success(data):
                guard let responseJSON = try? JSONDecoder().decode(SearchRecipesResponse.self, from: data) else {
                    DispatchQueue.main.async {
                        then(.failure(.invalidResponseFormat))
                    }
                    return
                }
                // by using map, we create an array of recipe
                let recipes = responseJSON.hits.map({ $0.recipe })
                print(recipes)
                then(.success(recipes))
                
            case let .failure(error):
                DispatchQueue.main.async {
                    then(.failure(.requestError(error as NSError)))
                }
            }
        }
    }
}

protocol NetworkServiceInterface {
    
    func request(parameters: [String : String], then: @escaping (Result<Data, Error>) -> Void)
}

final class NetworkService: NetworkServiceInterface {
        
    func request(parameters: [String : String], then: @escaping (Result<Data, Error>) -> Void) {
        AF.request("https://api.edamam.com/search", method: .get, parameters: parameters).responseJSON { response in
            
            if let error = response.error {
                then(.failure(error))
                return
            }
            
            if let data = response.data {
                then(.success(data))
            }
        }
    }
}

//unit test target

final class NetworkServiceMock: NetworkServiceInterface {
    
    var parameters: [String : String] = [:]
    
    func request(parameters: [String : String], then: @escaping (Result<Data, Error>) -> Void) {
        //...
        self.parameters = parameters
        
        then(.success(Data()))
    }
}
