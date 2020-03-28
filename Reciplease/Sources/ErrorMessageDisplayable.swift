//
//  ErrorMessageDisplayableProtocole.swift
//  Reciplease
//
//  Created by Claire on 20/02/2020.
//  Copyright © 2020 Claire Sivadier. All rights reserved.
//

import UIKit

//Centralize the error message
protocol ErrorMessageDisplayable: AnyObject {
    
    func show(_ error: Error)
}
// "where" keyword constrains the protocol extension to be only accessible to UIViewController instances that have conformence to this protocol.
// Other classes will have to provide their own implementation.
extension ErrorMessageDisplayable where Self: UIViewController {
    
    func show(_ error: Error) {
        let alertVC = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}

