//
//  HomeView.swift
//  quench
//
//  Created by prince ojinnaka on 02/05/2024.
//

import SwiftUI

struct HomeView: View {
    
    var body: some View {
        VStack {
            Text("Hello World!")
            
            Button(role: .destructive) {
                do {
                    try AuthService.shared.signOut()
                } catch {
                    print(error.localizedDescription)
                }
                
            } label: {
                Text("Sign Out")
            }
        }
        
    }
}

#Preview {
    HomeView()
        .modelContainer(for: Item.self, inMemory: true)
}
