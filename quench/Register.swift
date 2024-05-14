//
//  Register.swift
//  quench
//
//  Created by prince ojinnaka on 25/04/2024.
//

import SwiftUI
import SwiftData

struct RegisterView: View {
    @State var signInModel = SignInViewModel()
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var userName: String = ""
    @State var email: String = ""
    @State var password: String = ""
    
    var body: some View {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                VStack (spacing: 10) {
                    
                    Text("Quench")
                        .font(.system(size:40, weight: .light))
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    Spacer()
                    
                    VStack (spacing:50) {
                        HStack {
                            Text("First Name")
                                .font(.system(size:20, weight: .medium))
                                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                            TextField("Enter your first name", text:$firstName)
                                .multilineTextAlignment(.center)
                                .textFieldStyle(.roundedBorder)
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
                            Text("Email")
                                .font(.system(size:20, weight: .medium))
                                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                            TextField("Enter your Email", text:$userName)
                                .multilineTextAlignment(.center)
                                .textFieldStyle(.roundedBorder)
                                .padding()
                        }
                        
                        HStack {
                            Text("Password")
                                .font(.system(size:20, weight: .medium))
                                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                            TextField("Enter your password", text:$password)
                                .multilineTextAlignment(.center)
                                .textFieldStyle(.roundedBorder)
                                .padding()
                        }
                        
                        Button(action: {
                            signInModel.signUpWithEmail()                }) {
                                Text("Register")
                                    .font(.system(size: 25))
                                    .buttonStyle(AllButtonStyle())
                            }

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
