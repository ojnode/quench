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
            VStack (spacing:40) {
                Image(.homepage)
                    .resizable()
                Spacer()
                Text("Start your journey")
                
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
