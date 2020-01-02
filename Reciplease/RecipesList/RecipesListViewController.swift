//
//  RecipesListViewController.swift
//  Reciplease
//
//  Created by Claire on 01/01/2020.
//  Copyright © 2020 Claire Sivadier. All rights reserved.
//

import UIKit
import Alamofire

class RecipesListViewController: UIViewController {
    
    @IBOutlet var listTableView: UITableView!
    
    var model: RecipesListModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("RecipesListViewController")
        print(model)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
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
        return model?.numberOfRecipes() ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeTableViewCell", for: indexPath) as? RecipeTableViewCell else {
            return UITableViewCell()
        }
        
        if let recipe = model?.getRecipe(indexPath: indexPath) {
            cell.recipe = recipe
        }
        
        return cell
    }
}

extension RecipesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

