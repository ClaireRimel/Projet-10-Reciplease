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
    @IBOutlet var recipeImage: UIImageView!
    
    let gradientLayer = CAGradientLayer()
    
    var recipe: Recipe! {
        didSet {
            nameLabel.text = recipe.label
             
             if var ingredients = recipe.ingredientLines.first {
                 if recipe.ingredientLines.count > 1 {
                     ingredients += ", " + recipe.ingredientLines[1] + "..."
                 }
                 ingredientsLabel.text = ingredients
             }
                         
             AF.request(recipe.image).responseData { (response) in
                 switch response.result {
                 case let .success(data):
                     let image = UIImage(data: data)
                     DispatchQueue.main.async() {
                        self.recipeImage.image = image
                     }
                     
                 case .failure(let error):
                     print("error \(error.localizedDescription)")
                 }
             }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        UIView.addGradient(to: recipeImage)
    }
    
}
