//
//  FavoriteFetchable.swift
//  Reciplease
//
//  Created by Claire on 07/02/2020.
//  Copyright © 2020 Claire Sivadier. All rights reserved.
//

import Foundation

protocol FavoriteFetchableProtocol {
    
    func fetchRecipes() -> Result<[Recipe], Error>
    
}
