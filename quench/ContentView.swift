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
                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                Spacer()
                HStack {
                    Button("Regsiter") {
                        
                    }
                    Button("Sign In") {
                        
                    }
                }
                .buttonStyle(AllButtonStyle())
            }
        }
        
        
    }
}


#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}

struct AllButtonStyle: ButtonStyle {

  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
      .padding()
      .foregroundColor(.black)
      .background(configuration.isPressed ? Color.red : Color.blue)
      .cornerRadius(20.0)
  }

}
