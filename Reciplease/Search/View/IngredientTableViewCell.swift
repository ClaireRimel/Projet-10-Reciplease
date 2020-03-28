//
//  IngredientTableViewCell.swift
//  Reciplease
//
//  Created by Claire on 04/01/2020.
//  Copyright © 2020 Claire Sivadier. All rights reserved.
//

import UIKit

//implement the contents of the cell
final class IngredientTableViewCell: UITableViewCell {
    
    var ingredient: String = "" {
        didSet {
            textLabel?.text = "-   " + ingredient
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textLabel?.textColor = .white
    }
}
