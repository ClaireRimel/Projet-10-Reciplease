//
//  NetworkService.swift
//  Reciplease
//
//  Created by Claire on 07/03/2020.
//  Copyright © 2020 Claire Sivadier. All rights reserved.
//

import Foundation
import Alamofire

protocol NetworkServiceInterface {
    
    func request(parameters: [String : String], then: @escaping (Result<Data, Error>) -> Void)
}

final class NetworkService: NetworkServiceInterface {
    
    func request(parameters: [String : String], then: @escaping (Result<Data, Error>) -> Void) {
        AF.request("https://api.edamam.com/search", method: .get, parameters: parameters).responseJSON { response in
            
            if let error = response.error {
                then(.failure(error))
                return
            }
            
            if let data = response.data {
                then(.success(data))
            }
        }
    }
}
