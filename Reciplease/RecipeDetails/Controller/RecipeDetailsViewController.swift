//
//  RecipeDetailsViewController.swift
//  Reciplease
//
//  Created by Claire on 02/01/2020.
//  Copyright © 2020 Claire Sivadier. All rights reserved.
//

import UIKit
import Alamofire
import SafariServices
import CoreData

final class RecipeDetailsViewController: UIViewController {
    
    @IBOutlet var recipeImage: UIImageView!
    @IBOutlet var recipeLabel: UILabel!
    @IBOutlet var recipeTableView: UITableView!
    @IBOutlet var favoriteBarButtonItem: UIBarButtonItem!
    
    var model: RecipeDetailsModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeImage.layer.cornerRadius = 8
        // Do any additional setup after loading the view.
        model?.delegate = self
        
        if model?.checkFavStatus() == true {
            favoriteBarButtonItem.image = UIImage(systemName: "star.fill")
        } else {
            favoriteBarButtonItem.image = UIImage(systemName: "star")
        }
        
        UIView.addGradient(to: recipeImage)
        
        recipeLabel.text = model?.recipe.label
        recipeTableView.reloadData()
        
        model?.requestImage(then: { (result) in
            DispatchQueue.main.async() {
                switch result {
                case let .success(image):
                    self.recipeImage.image = image
                case .failure:
                    self.recipeImage.image = UIImage(named: "NoImageAvailable")
                }
            }
        })
    }
    
    @IBAction func getDirection() {
        if let url = model?.getURL() {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            
            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }
    
    @IBAction func didPressFavorite() {
        if model?.checkFavStatus() == false {
            model?.addToFavorite()
            favoriteBarButtonItem.image = UIImage(systemName: "star.fill")
            
        } else {
            favoriteBarButtonItem.image = UIImage(systemName: "star")
            model?.delete()
        }
    }
}

extension RecipeDetailsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.numberOfIngredients() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeInstructionTableViewCell", for: indexPath)
        cell.textLabel?.textColor = .white
        
        if let ingredient = model?.getDetails(for: indexPath) {
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

extension RecipeDetailsViewController: ErrorMessageDisplayable {
    
}
