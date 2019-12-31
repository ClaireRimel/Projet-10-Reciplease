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
            ingredientsTableView.reloadData()
            print(arrayIngredients)
        }
    }
    
    @IBAction func clearIngredients() {
        arrayIngredients.removeAll()
        ingredientsTableView.reloadData()
        print(arrayIngredients)
    }
}

extension SearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayIngredients.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientTableViewCell", for: indexPath) else {
//            return UITableViewCell()
//        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientTableViewCell", for: indexPath)

        cell.textLabel?.text = arrayIngredients[indexPath.row]
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
