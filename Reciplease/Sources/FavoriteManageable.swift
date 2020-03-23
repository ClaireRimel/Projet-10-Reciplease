//
//  FavoriteManageable.swift
//  Reciplease
//
//  Created by Claire on 08/03/2020.
//  Copyright © 2020 Claire Sivadier. All rights reserved.
//

import Foundation
import CoreData

protocol FavoriteManageable {
    
    func addToFavorite(recipe: Recipe) -> Result<NSManagedObject, Error>
    
    func delete(recipe: Recipe) -> Result<Void, Error>
    
    func checkFavStatus(recipe: Recipe) -> Result<Bool, Error>
    
}

