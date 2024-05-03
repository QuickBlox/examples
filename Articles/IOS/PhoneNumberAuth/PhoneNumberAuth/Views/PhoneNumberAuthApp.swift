//
//  PhoneNumberAuthApp.swift
//  PhoneNumberAuth
//
//  Created by Injoit on 30.04.2024.
//  Copyright © 2024 QuickBlox. All rights reserved.
//

import SwiftUI

@main
struct PhoneNumberAuthApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            EnterView()
        }
    }
}
