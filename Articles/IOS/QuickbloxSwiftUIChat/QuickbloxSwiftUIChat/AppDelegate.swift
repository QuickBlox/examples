//
//  AppDelegate.swift
//  QuickbloxSwiftUIChat
//
//  Created by Injoit on 31.08.2022.
//

import UIKit
import Quickblox
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions:
                        [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // Set QuickBlox credentials (You must create application in admin.quickblox.com).
        Quickblox.initWithApplicationId(0,
                                        authKey: "YourAuthKey",
                                        authSecret: "YourAuthSecret",
                                        accountKey: "YourAccountKey")
        
        // enabling carbons for chat
        QBSettings.carbonsEnabled = true
        // Enables Quickblox REST API calls debug console output.
        QBSettings.logLevel = .debug
        // Enables detailed XMPP logging in console output.
        QBSettings.enableXMPPLogging()
        QBSettings.disableFileLogging()
        QBSettings.autoReconnectEnabled = true
        
        return true
    }
}
