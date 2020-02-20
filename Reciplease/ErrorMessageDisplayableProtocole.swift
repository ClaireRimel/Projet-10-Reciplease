//
//  ErrorMessageDisplayableProtocole.swift
//  Reciplease
//
//  Created by Claire on 20/02/2020.
//  Copyright © 2020 Claire Sivadier. All rights reserved.
//

import UIKit

protocol ErrorMessageDisplayable: class {
    func show(_ error: Error)
}

extension ErrorMessageDisplayable where Self: UIViewController {
    func show(_ error: Error) {
        let alertVC = UIAlertController(title: "Erreur", message: error.localizedDescription, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}

