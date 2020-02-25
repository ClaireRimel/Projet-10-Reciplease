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
    @IBOutlet var searchView: UIView!
    
    let model = SearchModel()    
    var alert: UIAlertController?
    
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
        loader()
        model.searchRecipes { [weak self](result) in
            self?.alert?.dismiss(animated: false, completion: {
                switch result {
                case let .success(recipes):
                    self?.performSegue(withIdentifier: "RecipesList", sender: recipes)
                    
                case let .failure(error):
                    self?.show(error)
                }
            })
        }
    }
    
    func loader() {
        alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating()
        
        alert!.view.addSubview(loadingIndicator)
        self.present(alert!, animated: true, completion: nil)
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            model.removeIngredient(at: indexPath)
            ingredientsTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}

extension SearchViewController: ErrorMessageDisplayable {
    
}
