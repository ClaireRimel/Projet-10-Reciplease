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

final class RecipeDetailsViewController: UIViewController {
    
    @IBOutlet var recipeImage: UIImageView!
    @IBOutlet var recipeLabel: UILabel!
    @IBOutlet var recipeTableView: UITableView!
    
    var model: RecipeDetailsModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
    
    @IBAction func getDirectionButton() {
        if let url = model?.getURL() {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            
            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
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
