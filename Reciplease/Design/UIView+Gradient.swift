//
//  UIView+Gradient.swift
//  Reciplease
//
//  Created by Claire on 03/01/2020.
//  Copyright © 2020 Claire Sivadier. All rights reserved.
//

import UIKit

//Use a Gradient style of the imgage homogeneously
extension UIView {
    
   static func addGradient(to view: UIView) {
        //gradient layer
        let gradientLayer = CAGradientLayer()
        
        //define color
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.9).cgColor]
        
        //define locations of colors as NSNumbers in range from 0.0 to 1.0
        //if locations not provided the colors will spread evenly
        gradientLayer.locations = [0.3, 1.0]
        
        //define frame
        gradientLayer.frame = view.bounds
        
        //insert the gradient layer to the view layer
        view.layer.insertSublayer(gradientLayer, at: 1)
    }
}
