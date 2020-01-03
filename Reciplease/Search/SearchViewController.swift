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
    
    let model = SearchModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.delegate = self
    }
    
    
    @IBAction func addIngredient() {
        // optional binding
        if let text = ingredientsTextField.text {
            model.addIngredient(text: text)
        }
    }
    
    @IBAction func clearIngredients() {
        model.removeIngredients()
    }
    
    @IBAction func searchRecipes() {
        model.request { (result) in
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "RecipesList" {
            if let destination = segue.destination as? RecipesListViewController,
                let recipes = sender as? [Recipe] {
                let model = RecipesListModel(recipes: recipes)
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientTableViewCell", for: indexPath)

        cell.textLabel?.text = "-   " + model.getIngredient(indexPath: indexPath)
        cell.textLabel?.textColor = .white

        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension SearchViewController: SearchModelDelegate {
    
    func searchModelDidAddIngredient(_ searchModel: SearchModel) {
        ingredientsTextField.text = ""
        ingredientsTableView.reloadData()
    }
    
    func searchModelDidDeleteIngredients(_ searchModel: SearchModel) {
        ingredientsTableView.reloadData()
    }
}
