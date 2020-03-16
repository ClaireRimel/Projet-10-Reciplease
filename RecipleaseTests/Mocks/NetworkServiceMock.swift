//
//  NetworkServiceMock.swift
//  RecipleaseTests
//
//  Created by Claire on 08/03/2020.
//  Copyright © 2020 Claire Sivadier. All rights reserved.
//
@testable import Reciplease
import Foundation

final class NetworkServiceMock: NetworkServiceInterface {
    
    var parameters: [String : String] = [:]
    
    var result: Result<Data, Error>?
    
    func request(parameters: [String : String], then: @escaping (Result<Data, Error>) -> Void) {
        self.parameters = parameters
        
        if let result = result {
            then(result)
        }
    }
}
