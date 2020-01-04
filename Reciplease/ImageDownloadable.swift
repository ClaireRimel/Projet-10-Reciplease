//
//  ImageDownloadable.swift
//  Reciplease
//
//  Created by Claire on 04/01/2020.
//  Copyright © 2020 Claire Sivadier. All rights reserved.
//

import UIKit
import Alamofire

protocol ImageDownloadable {
    
    func requestImage(url: String, then: @escaping (Result<UIImage, Error>) -> Void)
}

extension ImageDownloadable {
    
    func requestImage(url: String, then: @escaping (Result<UIImage, Error>) -> Void) {
        AF.request(url).responseData { (response) in
            switch response.result {
            case let .success(data):
                guard let image = UIImage(data: data) else {
                    let error = NSError(domain: "", code: 0, userInfo: nil)
                    then(.failure(error))
                    return
                }
                
                then(.success(image))
                
            case .failure(let error):
                print("error \(error.localizedDescription)")
                then(.failure(error))
            }
        }
    }
}
