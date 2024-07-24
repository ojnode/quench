//
//  HomeView.swift
//  quench
//
//  Created by prince ojinnaka on 02/05/2024.
//

import SwiftUI

struct HomeView: View {
    @State var signedOut: Bool = false
    @StateObject var BMIClass = AccessUserAttributes()
    @StateObject var units = localStorage()
    let defaults = UserDefaults.standard
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                VStack(spacing:20) {

                    HStack(spacing: 90) {
                        NavigationLink(destination: SetGoal()
                            .environmentObject(BMIClass)
                            .environmentObject(units)
                        )
                        {
                            Image(systemName: "person.crop.circle")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                        }
                        
                            CreateText(label: "Quench", size: 25)
        
                            Image(systemName: "gearshape")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                        
                    }
                    .onAppear {
                        print(defaults.bool(forKey: "isAttributesSet"))
                    }
                  
                    DisplayOption(isGoalSet: defaults.bool(forKey: "isAttributesSet"))
                        .environmentObject(BMIClass)
                        .environmentObject(units)
                    
                    VStack(spacing:25) {
                            VStack (spacing:25) {
                                Image(systemName: "map.circle")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                Text("Go to Map")
                                    .foregroundColor(.black)
                                
                            }
            
                        VStack (spacing:25) {
                            Image(systemName: "map.circle")
                                .resizable()
                                .frame(width: 60, height: 60)
                            Text("Go to Map")
                                .foregroundColor(.black)
                            
                        }
                        
                        Spacer()
                        
                        Button(action: {AuthService.shared.signOut(); signedOut = true;
                            resetLocalStorage() // display error message later
                        }, label: {
                            Text("Sign out")
                        })
                        .navigationDestination(isPresented: $signedOut) {
                            ContentView()
                        }
                        .buttonStyle(AllButtonStyle())
                    }
                    Spacer()
                }
                .onAppear  {
                    Task {
                        try await BMIClass.displayAttributes()
                        BMIClass.calculateBodyMassIndex()
                    }
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
    @EnvironmentObject var BMIClass: AccessUserAttributes
    @EnvironmentObject var units: localStorage
    
    var isGoalSet: Bool
    
    var image: String {
        get {isGoalSet ? "Progress" : "Homepage"}
    }
    
    var destination: AnyView {
        get {isGoalSet ? AnyView(ProgressTracker()
            .environmentObject(BMIClass)
            .environmentObject(units)
        ) : AnyView(SetGoal()
            .environmentObject(BMIClass)
        )
        }
    }
    
    var body: some View {
            NavigationLink (destination: destination) {
                CreateImageView(image: image, width: 2, height: 1, radius: 40)
            }
        }
}
