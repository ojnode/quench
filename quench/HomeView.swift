//
//  HomeView.swift
//  quench
//
//  Created by prince ojinnaka on 02/05/2024.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct HomeView: View {
    @State var signedOut: Bool = false
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                VStack {
                    VStack {
                        CreateText(label: "Quench", size: 25)
                    }
                    
                    
                    Stats()
                    
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

struct Stats: View {
    @State var isGoalSet: Bool = false
    
    // check set Goal tomorrow , you can throw error again without do catch  check!!!!!!!!!
    
    var body: some View {
        Group {
            if !isGoalSet {
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
        .onAppear {
            Task {
                isGoalSet = await checkGoalSet()
            }
        }
    }
    
    func checkGoalSet() async -> Bool {
        let db = Firestore.firestore().collection("users")
        let user = Auth.auth().currentUser
        
        guard let user = user?.uid else {
            return false
        }
        
        do {
            let document = try await db.document("\(user)").getDocument()
            return document.exists
        } catch {
            return false
        }
    }
}
