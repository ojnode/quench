//
//  quechAuth.swift
//  quench
//
//  Created by prince ojinnaka on 30/04/2024.
//

import SwiftUI
import FirebaseCore
import UIKit
import GooglePlaces
import GoogleMaps

// no changes in your AppDelegate class
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        GMSServices.provideAPIKey("AIzaSyD9V32q9l3YFrcz6I2_sUc4WzW-u-bJMhw")
        GMSPlacesClient.provideAPIKey("AIzaSyD9V32q9l3YFrcz6I2_sUc4WzW-u-bJMhw")
        return true
    }
}


@main
struct quenchAuthApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if (AuthService.shared.currentUser != nil) {
                    HomeView()
                } else {
                    GoogleMapsView()
                }
            }
        }
    }
}
