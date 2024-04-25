//
//  Register.swift
//  quench
//
//  Created by prince ojinnaka on 25/04/2024.
//

import SwiftUI
import SwiftData

struct RegisterView: View {
    @State var email: String = ""
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            VStack (spacing: 35) {
                
                Text("Quench")
                    .font(.system(size:20, weight: .light))
                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                VStack {
                    HStack {
                        Text("First Name")
                            .font(.system(size:15, weight: .medium))
                            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                        TextField("Enter your username or email", text:$email)
                            .multilineTextAlignment(.center)
                            .textFieldStyle(.roundedBorder)
                            .padding()
                        
                    }
                }
                Spacer()
            }
 
        }

    }
    
}

#Preview {
    RegisterView()
        .modelContainer(for: Item.self, inMemory: true)
}
