//
//  Register.swift
//  quench
//
//  Created by prince ojinnaka on 25/04/2024.
//

import SwiftUI
import SwiftData

struct RegisterView: View {
    @State var userSession = UserSession()
    @State var firstName = ""
    @State var lastName = ""
    @State var userName = ""
    @State var email = ""
    @State var password  = ""
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack (spacing: 20) {
                Text("Quench")
                    .font(.system(size:40, weight: .medium))
                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                Spacer()
                
                VStack (spacing:50) {
                    
                    createEntryField(label: "First Name", text: $firstName)
                    
                    createEntryField(label: "Last Name", text: $lastName)
                    
                    createEntryField(label: "Username", text: $userName)
                    
                    createEntryField(label: "Email", text:
                        $email)

                    createEntryField(label: "Password", text: $password)

                    
                    Button("Register") {
                        userSession.signUpWithEmail()
                    }
                    .buttonStyle(AllButtonStyle())
                    
                    HStack {
                        Text("Already have an account?")
                            .font(.system(size:20, weight: .medium))
                            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                        
                        NavigationLink(destination: ContentView().navigationBarBackButtonHidden(true)) {
                            Text("Login")
                                .font(.system(size:20, weight: .medium))
                                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    RegisterView()
        .modelContainer(for: Item.self, inMemory: true)
}
