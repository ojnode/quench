//
//  HomeView.swift
//  quench
//
//  Created by prince ojinnaka on 02/05/2024.
//

import SwiftUI

struct HomeView: View {
    @State var signedOut: Bool = false
    @State var checkAttributesSet: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                VStack {
                    VStack {
                        CreateText(label: "Quench", size: 25)
                    }
                    .task {
                        checkAttributesSet = await firebaseStoreUser().checkattributesSet()
                    }
                    DisplayOption(isGoalSet: checkAttributesSet)
                    
                    VStack(spacing:25) {
                                                
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
                        
                        Button(action: {AuthService.shared.signOut(); signedOut = true}, label: {
                            Text("Sign out")
                        })
                        .navigationDestination(isPresented: $signedOut) {
                            ContentView()
                        }
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

struct DisplayOption: View {
    var isGoalSet: Bool
    
    var image: String {
        get {isGoalSet ? "Progress" : "Homepage"}
    }
    
    var destination: AnyView {
        get {isGoalSet ? AnyView(ProgressTracker()) : AnyView(SetGoal())}
    }
    
    var body: some View {
        NavigationLink (destination: destination) {
            CreateImageView(image: image, width: 2, height: 1, radius: 40)
        }
    }
}
