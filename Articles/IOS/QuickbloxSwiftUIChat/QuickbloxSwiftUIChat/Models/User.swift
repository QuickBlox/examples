//
//  User.swift
//  QuickbloxSwiftUIChat
//
//  Created by Injoit on 26.12.2022.
//

import UIKit
import Quickblox

struct User: Identifiable {
    
    private var user: QBUUser!
    
    init(user: QBUUser) {
        self.user = user
    }
    
    //MARK - Properties
    var id: String {
        return String(user.id)
    }
    
    var fullName: String {
        return user.fullName ?? "QBUser"
    }

    var login: String {
        return user.login!
    }
    
    var password: String {
        return user.password!
    }
    
    var customData: String? {
        return user.customData
    }
    
    var createdAt: Date? {
        return user.createdAt
    }
    
    var lastRequestAt: Date? {
        return user.lastRequestAt
    }
    
    var avatarColor: UIColor {
        return UInt(user.createdAt!.timeIntervalSince1970).generateColor()
    }
    
    var avatarCharacter: String {
        return String(fullName.stringByTrimingWhitespace().capitalized.first ?? Character("C"))
    }
}
