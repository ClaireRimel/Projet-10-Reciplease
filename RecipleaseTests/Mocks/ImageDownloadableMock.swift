//
//  ImageDownloadableMock.swift
//  RecipleaseTests
//
//  Created by Claire on 08/03/2020.
//  Copyright © 2020 Claire Sivadier. All rights reserved.
//
@testable import Reciplease
import UIKit

final class ImageDownloadableMock: ImageDownloadable {
    var url: String?
    var result: Result<UIImage, Error>?
    
    func requestImage(url: String, then: @escaping (Result<UIImage, Error>) -> Void) {
        self.url = url
        if let result = result {
            then(result)
        }
    }
}
