//
//  RecipeDetailsModel.swift
//  Reciplease
//
//  Created by Claire on 02/01/2020.
//  Copyright © 2020 Claire Sivadier. All rights reserved.
//

import Foundation
import Alamofire

final class RecipeDetailsModel {
    
    let recipe: Recipe
    
    init(recipe: Recipe) {
        self.recipe = recipe
    }
    
    func getDetails(for indexPath: IndexPath) -> String {
        return recipe.ingredientLines[indexPath.row]
    }
    
    func numberOfIngredients() -> Int {
        return recipe.ingredientLines.count
    }
    
    func getURL() -> URL? {
        return URL(string: recipe.url)
    }
    
    func requestImage(then: @escaping (Result<UIImage, Error>) -> Void) {
        AF.request(recipe.image).responseData { (response) in
            switch response.result {
            case let .success(data):
                guard let image = UIImage(data: data) else {
                    let error = NSError(domain: "", code: 0, userInfo: nil)
                    then(.failure(error))
                    return
                }
                
                then(.success(image))
                
            case .failure(let error):
                print("error \(error.localizedDescription)")
                then(.failure(error))
            }
        }
    }
}
