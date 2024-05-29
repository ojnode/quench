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
                    
                    CreateEntryField(label: "First Name", text: $userSession.firstName)
                    
                    CreateEntryField(label: "Last Name", text: $userSession.lastName)
                    
                    CreateEntryField(label: "Username", text: $userSession.userName)
                    
                    CreateEntryField(label: "Email", text:
                                        $userSession.email)
                    
                    CreateEntryField(label: "Password", text: $userSession.password, 
                                     secure: true)
                    
                    Button("Register") {
                        Task {
                            let result = await userSession.signUpWithEmail()
                        }
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
        .onTapGesture {
            hideKeyboard()
        }
    }
}

#Preview {
    RegisterView()
        .modelContainer(for: Item.self, inMemory: true)
}
