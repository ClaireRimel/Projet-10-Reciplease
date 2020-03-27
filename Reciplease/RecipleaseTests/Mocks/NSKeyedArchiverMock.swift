//
//  NSKeyedArchiverMock.swift
//  Reciplease
//
//  Created by Claire on 27/03/2020.
//  Copyright © 2020 Claire Sivadier. All rights reserved.
//

import Foundation

final class NSKeyedArchiverMock: NSKeyedArchiver {
    
    override class func archivedData(withRootObject object: Any, requiringSecureCoding requiresSecureCoding: Bool) throws -> Data {
        throw NSError(domain: "", code: 0, userInfo: nil)
    }
    
}
