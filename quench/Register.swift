//
//  Register.swift
//  quench
//
//  Created by prince ojinnaka on 25/04/2024.
//

import SwiftUI

struct RegisterView: View {
    @State var userSession = UserSession()
    @State var isRegistered = false
    @State var logError: String = ""

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    Text("Quench")
                        .font(.system(size: 40, weight: .medium))
                        .foregroundColor(.blue)
                    Spacer()

                    VStack(spacing: 40) {
                        CreateEntryField(label: "First Name", 
                                         text: $userSession.firstName)
                        CreateEntryField(label: "Last Name", 
                                         text: $userSession.lastName)
                        CreateEntryField(label: "Username", 
                                         text: $userSession.userName)
                        CreateEntryField(label: "Email", 
                                         text: $userSession.email)
                        CreateEntryField(label: "Password",
                                         text: $userSession.password, secure: true)

                        Button(action: {
                            Task {  
                                do
                                    {
                                isRegistered = try await userSession.signUpWithEmail()
                                hideKeyboard()
                            } catch let error as LogStatusError {
                                if case let .authorizationDenied(string) = error {
                                    isRegistered = false
                                    logError = string
                                    }
                                }
                            }
                        }) {
                                Text("Register")
                        }
                        .navigationDestination(isPresented: $isRegistered) {
                            SuccessLogin()
                        }
                        .buttonStyle(AllButtonStyle())
                        
                        
                        if !isRegistered {
                            CreateText(label: "\(logError)", size: 15, weight: .light, color: .red)
                        }
                        
                        HStack {
                            Text("Already have an account?")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.blue)

                            NavigationLink(destination: ContentView().navigationBarBackButtonHidden(true)) {
                                Text("Login")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
                .padding()
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
