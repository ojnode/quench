//
//  Register.swift
//  quench
//
//  Created by prince ojinnaka on 25/04/2024.
//

import SwiftUI
import SwiftData

struct RegisterView: View {
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var userName: String = ""
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            VStack (spacing: 35) {
                
                Text("Quench")
                    .font(.system(size:20, weight: .light))
                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                VStack (spacing:50) {
                    HStack {
                        Text("First Name")
                            .font(.system(size:20, weight: .medium))
                            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                        TextField("Enter your first name", text:$firstName)
                            .multilineTextAlignment(.center)
                            .textFieldStyle(.roundedBorder)
                            .padding()
                    }
                    
                    HStack {
                        Text("Last Name")
                            .font(.system(size:20, weight: .medium))
                            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                        TextField("Enter your last name", text:$lastName)
                            .multilineTextAlignment(.center)
                            .textFieldStyle(.roundedBorder)
                            .padding()
                    }
                    
                    HStack {
                        Text("Username")
                            .font(.system(size:20, weight: .medium))
                            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                        TextField("Enter your username", text:$userName)
                            .multilineTextAlignment(.center)
                            .textFieldStyle(.roundedBorder)
                            .padding()
                    }
                    
                    HStack {
                        Text("Password")
                            .font(.system(size:20, weight: .medium))
                            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                        TextField("Enter your password", text:$userName)
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
