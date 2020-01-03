//
//  RecipeDetailsViewController.swift
//  Reciplease
//
//  Created by Claire on 02/01/2020.
//  Copyright © 2020 Claire Sivadier. All rights reserved.
//

import UIKit
import Alamofire

class RecipeDetailsViewController: UIViewController {
    
    @IBOutlet var recipeImage: UIImageView!
    @IBOutlet var recipeLabel: UILabel!
    @IBOutlet var recipeTableView: UITableView!
    
    @IBAction func getDirectionButton() {}
    
    var model: RecipeDetailsModel?
    
//   var recipe: Recipe! {
//             didSet {
//                 recipeLabel.text = recipe.label
//
//                 var ingredients = recipe.ingredientLines
//                      recipeTableView = ingredients
//                  }
//
//                  AF.request(recipe.image).responseData { (response) in
//                      switch response.result {
//                      case let .success(data):
//                          let image = UIImage(data: data)
//                          DispatchQueue.main.async() {
//                             self.recipeImage.image = image
//                          }
//
//                      case .failure(let error):
//                          print("error \(error.localizedDescription)")
//                      }
//                  }
//             }
//         }

    override func viewDidLoad() {
        super.viewDidLoad()
        UIView.addGradient(to: recipeImage)
        // Do any additional setup after loading the view.
        print("RecipeDetailsViewController")
        print(model)
        
        recipeLabel.text = model?.recipe.label
        if let imageUrl = model?.recipe.image {
            AF.request(imageUrl).responseData { (response) in
                switch response.result {
                case let .success(data):
                    let image = UIImage(data: data)
                    DispatchQueue.main.async() {
                        self.recipeImage.image = image
                    }
                    
                case .failure(let error):
                    print("error \(error.localizedDescription)")
                }
            }
        }
        
        recipeTableView.reloadData()
    }
}

extension RecipeDetailsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
           return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.recipeInstruction() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeInstructionTableViewCell", for: indexPath)
        cell.textLabel?.textColor = .white
        
        if let ingredient = model?.getDetails(indexPath: indexPath) {
            cell.textLabel?.text = ingredient
        }
        return cell
    }
}

extension RecipeDetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
