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
    @IBOutlet var timeLabel: UILabel!
    
    var recipe: Recipe! {
        didSet {
            recipeImageView.image = nil
            nameLabel.text = recipe.label
            
            if recipe.totalTime == 0 {
                timeLabel.isHidden = true
            } else {
                timeLabel.isHidden = false
                timeLabel.text = " 🕒 \(formatter(time: recipe.totalTime))   "
            }
            
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
    
    func formatter(time: Int) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .short
        formatter.maximumUnitCount = 2
        
        return formatter.string(from: Double(time * 60 )) ?? ""
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        timeLabel.layer.cornerRadius = 8
        timeLabel.clipsToBounds = true
    }
}
