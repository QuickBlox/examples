//
//  QuickbloxSwiftUIChatApp.swift
//  QuickbloxSwiftUIChat
//
//  Created by Injoit.
//

import SwiftUI
import Quickblox

@main
struct QuickbloxSwiftUIChatApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            LoginScreen()
        }
    }
}
