//
//  quechAuth.swift
//  quench
//
//  Created by prince ojinnaka on 30/04/2024.
//

import SwiftUI
import FirebaseCore

@main
struct quenchAuthApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if (AuthService.shared.currentUser != nil) {
                    HomeView()
                } else {
                    ContentView()
                }
            }
        }
    }
}
