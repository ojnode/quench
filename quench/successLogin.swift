//
//  successLogin.swift
//  quench
//
//  Created by prince ojinnaka on 11/06/2024.
//

import SwiftUI

struct SuccessLogin: View {
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                VStack (spacing:30) {
                    CreateText(label: "Registration successful", size: 25)
                    NavigationLink(destination: ContentView()
                        .navigationBarBackButtonHidden(true)) {
                            CreateText(label: "Login", size: 30, color: .black)
                    }
                    .buttonStyle(AllButtonStyle())
                
                    Spacer()
                }
            }
        }
    }
   
}

#Preview {
    SuccessLogin()
}
