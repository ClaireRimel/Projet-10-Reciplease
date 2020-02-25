//
//  SearchViewController.swift
//  Reciplease
//
//  Created by Claire on 31/12/2019.
//  Copyright © 2019 Claire Sivadier. All rights reserved.
//

import UIKit

final class SearchViewController: UIViewController {
    
    @IBOutlet var ingredientsTextField: UITextField!
    @IBOutlet var ingredientsTableView: UITableView!
    
    let model = SearchModel()
        
    @IBAction func addIngredient() {
        if let text = ingredientsTextField.text {
            model.add(ingredient: text)
        }
        ingredientsTextField.resignFirstResponder()
        ingredientsTextField.text = ""
        ingredientsTableView.reloadData()
    }
    
    @IBAction func removeIngredients() {
        model.removeIngredients()
        ingredientsTableView.reloadData()
    }
    
    @IBAction func searchRecipes() {
        model.searchRecipes { (result) in
            switch result {
            case let .success(recipes):
                self.performSegue(withIdentifier: "RecipesList", sender: recipes)
                
            case let .failure(error):
                let alertVC = UIAlertController(title: "Erreur", message: error.message, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alertVC, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RecipesList" {
            if let destination = segue.destination as? RecipesListViewController,
                let recipes = sender as? [Recipe] {
                let model = RecipesListModel(source: .search(recipes))
                destination.model = model
            }
        }
    }
}

extension SearchViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.numberOfIngredients()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientTableViewCell", for: indexPath) as? IngredientTableViewCell else {
            return UITableViewCell()
        }
        
        cell.ingredient = model.getIngredient(for: indexPath)
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
