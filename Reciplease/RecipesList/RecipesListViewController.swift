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
            cell.nameLabel.text = recipe.label
            
            if var ingredients = recipe.ingredientLines.first {
                if recipe.ingredientLines.count > 1 {
                    ingredients += ", " + recipe.ingredientLines[1] + "..."
                }
                cell.ingredientsLabel.text = ingredients
            }
                        
            AF.request(recipe.image).responseData { (response) in
                switch response.result {
                case let .success(data):
                    let image = UIImage(data: data)
                    DispatchQueue.main.async() {
                        cell.recipeImage.image = image
                    }
                    
                case .failure(let error):
                    print("error \(error.localizedDescription)")
                }
            }
        }
        
         
        return cell
    }
}

extension RecipesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
