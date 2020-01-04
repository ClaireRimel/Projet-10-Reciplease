//
//  RecipesListViewController.swift
//  Reciplease
//
//  Created by Claire on 01/01/2020.
//  Copyright © 2020 Claire Sivadier. All rights reserved.
//

import UIKit
import Alamofire

final class RecipesListViewController: UIViewController {
    
    @IBOutlet var listTableView: UITableView!
    
    var model: RecipesListModel?

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RecipeDetails" {
            if let destination = segue.destination as? RecipeDetailsViewController,
                let cell = sender as? RecipeTableViewCell {
                let model = RecipeDetailsModel(recipe: cell.recipe)
                destination.model = model
            }
        }
    }
}


extension RecipesListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.numberOfRecipes() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeTableViewCell", for: indexPath) as? RecipeTableViewCell else {
            return UITableViewCell()
        }
        
        if let recipe = model?.getRecipe(for: indexPath) {
            cell.recipe = recipe
        }
//        // capture list
//        model?.requestImage(for: indexPath, then: { [cell] (result) in
//            switch result {
//            case let .success(image):
//                cell.recipeImageView.image = image
//            case .failure:
//                cell.recipeImageView.image = UIImage(named: "NoImageAvailable")
//            }
//        })
        
        return cell
    }
}

extension RecipesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        // capture list
        model?.requestImage(for: indexPath, then: { (result) in
            if let cell = tableView.cellForRow(at: indexPath) as? RecipeTableViewCell {
                switch result {
                case let .success(image):
                    cell.recipeImageView.image = image
                case .failure:
                    cell.recipeImageView.image = UIImage(named: "NoImageAvailable")
                }
            }
        })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
