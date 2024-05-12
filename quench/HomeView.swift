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
                NavigationLink(destination: SetGoal()) {
                    Image(.homepage)
                        .resizable()
                        .aspectRatio(2, contentMode: .fit)
                        .cornerRadius(25)
                        .padding()
                }
                
                VStack (spacing:40) {
                    
                    Spacer()
                    
                    Text("map")
                    
                    Text("socials")
                }
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: Item.self, inMemory: true)
}
