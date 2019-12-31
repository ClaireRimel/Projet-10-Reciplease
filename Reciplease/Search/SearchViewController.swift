//
//  SearchViewController.swift
//  Reciplease
//
//  Created by Claire on 31/12/2019.
//  Copyright © 2019 Claire Sivadier. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet var ingredientsTextField: UITextField!
    @IBOutlet var ingredientsTableView: UITableView!
    var arrayIngredients: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func addIngredient() {
        // optional binding
        if let text = ingredientsTextField.text {
            arrayIngredients.append(text)
            ingredientsTextField.text = ""
            print(arrayIngredients)
        }
    }
    
    @IBAction func clearIngredients() {
        arrayIngredients.removeAll()
        print(arrayIngredients)
    }

}
