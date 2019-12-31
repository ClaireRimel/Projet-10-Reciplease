//
//  SearchModel.swift
//  Reciplease
//
//  Created by Claire on 31/12/2019.
//  Copyright © 2019 Claire Sivadier. All rights reserved.
//

import Foundation

class SearchModel {
    
    private var arrayIngredients: [String] = []

    func addIngredient(text: String) {
        arrayIngredients.append(text)
    }
    
    func removeIngredients() {
        arrayIngredients.removeAll()
    }
    
    func numberOfIngredients() -> Int {
        return arrayIngredients.count
    }
    
    func getIngredient(indexPath: IndexPath) -> String {
        return arrayIngredients[indexPath.row]
    }
}
