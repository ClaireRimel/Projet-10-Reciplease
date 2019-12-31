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
}


