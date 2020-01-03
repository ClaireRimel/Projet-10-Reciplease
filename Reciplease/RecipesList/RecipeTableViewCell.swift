//
//  RecipeTableViewCell.swift
//  Reciplease
//
//  Created by Claire on 02/01/2020.
//  Copyright © 2020 Claire Sivadier. All rights reserved.
//

import UIKit
import Alamofire

class RecipeTableViewCell: UITableViewCell {

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
        addGradientToView(view: recipeImage)
    }
    
    func addGradientToView(view: UIImageView) {
        //gradient layer
        let gradientLayer = CAGradientLayer()
        
        //define color
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.9).cgColor]
        
        //define locations of colors as NSNumbers in range from 0.0 to 1.0
        //if locations not provided the colors will spread evenly
        gradientLayer.locations = [0.3, 1.0]
        
        //define frame
        gradientLayer.frame = view.bounds
        
        //insert the gradient layer to the view layer
        view.layer.insertSublayer(gradientLayer, at: 1)
    }
     
}
