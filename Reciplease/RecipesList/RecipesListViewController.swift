//
//  RecipesListViewController.swift
//  Reciplease
//
//  Created by Claire on 01/01/2020.
//  Copyright © 2020 Claire Sivadier. All rights reserved.
//

import UIKit

class RecipesListViewController: UIViewController {
    
    @IBOutlet var listTableView: UITableView!
    
    var model: RecipesListModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("RecipesListViewController")
        print(model)
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipesListTableViewCell", for: indexPath)
        
        if let recipe = model?.getRecipe(indexPath: indexPath) {
            cell.textLabel?.text = recipe.label
            if var ingredients = recipe.ingredientLines.first {
                if recipe.ingredientLines.count > 1 {
                    ingredients += ", " + recipe.ingredientLines[1] + "..."
                }
                cell.detailTextLabel?.text = ingredients
            }
        }

        return cell
    }
}
