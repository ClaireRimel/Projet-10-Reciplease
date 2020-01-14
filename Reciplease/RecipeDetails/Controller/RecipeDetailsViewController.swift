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
    
    @IBAction func didPressFavorite() {
        
    }
    
//    func save(name:String)
//    {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//
//        //Data is in this case the name of the entity
//        let entity = NSEntityDescription.entity(forEntityName: "RecipeEntity",
//                                                in: context)
//        var newValue = NSManagedObject(entity: entity!,
//                                      insertInto:context)

//        newValue.setValue(model!.recipe.label, forKey: "label")
//        newValue.setValue(model!.recipe.image, forKey: "image")
//        newValue.setValue(model!.recipe.url, forKey: "url")
//        newValue.setValue(model!.recipe.ingredientLines, forKey: "ingredientLines")
//
//       do {
//           try context.save()
//          } catch {
//           print("Failed saving")
//        }
        
//        let managedContext =
//            appDelegate.persistentContainer.viewContext
//
//        let fetchRequest =
//            NSFetchRequest<NSManagedObject>(entityName: "RecipeEntity")
        
        //3
//        do {
//            newValue = try managedContext.fetch(fetchRequest)
//        } catch let error as NSError {
//            print("Could not fetch. \(error), \(error.userInfo)")
//        }
//
        
        //uncomment this line for adding the stored object to the core data array
        //name_list.append(options)
//    }
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
