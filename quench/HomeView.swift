//
//  HomeView.swift
//  quench
//
//  Created by prince ojinnaka on 02/05/2024.
//

import SwiftUI

struct HomeView: View {
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                VStack {
                    VStack {
                        CreateText(label: "Quench", size: 25)
                    }
                    
                    VStack(spacing:25) {
                        Stats()
                        
                        NavigationLink(destination: GoogleMapsView()) {
                            VStack (spacing:25) {
                                Image(systemName: "map.circle")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                Text("Go to Map")
                                    .foregroundColor(.black)
                                
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.blue)
                        .cornerRadius(20)
                        .buttonStyle(AllButtonStyle())
                        
                        NavigationLink(destination: GoogleMapsView()) {
                            VStack (spacing:25) {
                                Image(systemName: "map.circle")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                Text("Go to Map")
                                    .foregroundColor(.black)
                                
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.blue)
                        .cornerRadius(20)
                        .buttonStyle(AllButtonStyle())
                        
                        Spacer()
                        
                        Button(action: {AuthService.shared.signOut()}, label: {
                            Text("Sign out")
                        })
                        .buttonStyle(AllButtonStyle())
                    }
                    Spacer()
                
                    
                }
            }
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
                        .cornerRadius(20)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                }
            }
        } else {
            Text("percentage reduced")
            Text("percentage reduced")
            Text("percentage reduced")
        }
    }
}
