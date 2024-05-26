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
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var userName: String = ""
    @State var email: String = ""
    @State var password: String = ""
    
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
                    
                    createEntryField(Label: "First Name", text: $firstName)
                    
                    createEntryField(Label: "Last Name", text: $lastName)
                    
                    createEntryField(Label: "Username", text: $userName)
                    
                    createEntryField(Label: "Email", text: 
                        $email)

                    createEntryField(Label: "Password", text: $password)

                    
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
