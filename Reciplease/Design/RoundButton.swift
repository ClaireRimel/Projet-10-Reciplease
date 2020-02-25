//
//  RoundButton.swift
//  Reciplease
//
//  Created by Claire on 25/02/2020.
//  Copyright © 2020 Claire Sivadier. All rights reserved.
//

import UIKit

class RoundButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 8
    }
}
