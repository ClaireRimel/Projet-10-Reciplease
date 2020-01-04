//
//  RecipeTableViewCell.swift
//  Reciplease
//
//  Created by Claire on 02/01/2020.
//  Copyright © 2020 Claire Sivadier. All rights reserved.
//

import UIKit
import Alamofire

final class RecipeTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var ingredientsLabel: UILabel!
    @IBOutlet var recipeImageView: UIImageView!
    
    var recipe: Recipe! {
        didSet {
            recipeImageView.image = nil
            nameLabel.text = recipe.label
            
            if var ingredients = recipe.ingredientLines.first {
                if recipe.ingredientLines.count > 1 {
                    ingredients += ", " + recipe.ingredientLines[1] + "..."
                }
                ingredientsLabel.text = ingredients
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        UIView.addGradient(to: recipeImageView)
    }
}
