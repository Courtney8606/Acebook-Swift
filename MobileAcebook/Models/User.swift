//
//  User.swift
//  MobileAcebook
//
//  Created by Josué Estévez Fernández on 01/10/2023.
//
//
//  User.swift
//  MobileAcebook
//
//  Created by Josué Estévez Fernández on 01/10/2023.
//

import UIKit
import Foundation
import SwiftUI

public struct User: Codable {
    var _id: String?
    var email: String
    var password: String
    var username: String
    var imgUrl: String?
    
    init(_id: String, email: String, password: String, username: String, imgUrl: String) {
        self._id = _id
        self.email = email
        self.password = password
        self.username = username
        self.imgUrl = imgUrl
    }
    func constructedUser() -> String {
            return "User(\(self._id), \"\(self.email)\", \"\(self.password)\", \"\(self.username)\")"
        }
    
}
    
    
    
    
