//
//  HomeView.swift
//  quench
//
//  Created by prince ojinnaka on 02/05/2024.
//

import SwiftUI

struct HomeView: View {
    
    var body: some View {
        ZStack {
               Stats()
                }
                
                VStack (spacing:40) {
                    
                Spacer()
                
                    
                    Text("socials")
                    
                    Button(action: {AuthService.shared.signOut()}, label: {
                        Text("Sign out")
                    })
                }
        }
    }


#Preview {
    HomeView()
        .modelContainer(for: Item.self, inMemory: true)
}

struct Stats: View {
    var setGoals: Bool = false
    
    var body: some View {
        if !(setGoals) {
            ZStack {
                NavigationLink(destination: SetGoal()) {
                    Image(.homepage)
                        .resizable()
                        .aspectRatio(2, contentMode: .fit)
                        .cornerRadius(25)
                        .padding()
                }
            }
        } else {
            Text("percentage reduced")
            Text("percentage reduced")
            Text("percentage reduced")
        }
    }
}
