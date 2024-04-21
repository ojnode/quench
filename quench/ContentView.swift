//
//  ContentView.swift
//  quench
//
//  Created by prince ojinnaka on 21/04/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
        
    var body: some View {
        ZStack{
            Color.purple
                .ignoresSafeArea()
            VStack {
                Text("Quench")
                    .font(.system(size:70, weight: .medium))
                Spacer()
                HStack {
                    Button("Regsiter") {
                        
                    }
                    Button("Sign In") {
                        
                    }
                }
                .buttonStyle(.bordered)
            }
        }
        
        
    }
}


#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
