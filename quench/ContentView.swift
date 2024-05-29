//  ContentView.swift
//  quench
//
//  Created by prince ojinnaka on 21/04/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State var userSession = UserSession()
    @State var loginResult = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                VStack (spacing:40) {
                    
                    VStack {
                        CreateText(label: "Quench", size: 70, weight: .medium)
                        
                        CreateText(label: "One day at a time", size: 20, design: .serif)
                    }
                    Spacer()
                    
                    VStack (spacing:10) {
                        
                        CreateTextField(text: "Enter your username or email", inputText: $userSession.email)
                        
                        CreateSecureField(text: "Password", inputText: $userSession.password)
                        
                        Button("Sign In") {
                            Task {
                               let result = await userSession.signInWithEmail()
                                loginResult = result
                    
                            }
                        }
                        .buttonStyle(AllButtonStyle())
                        Spacer()
                        
                        NavigationLink(destination: RegisterView().navigationBarBackButtonHidden(true)) {
                            HStack {
                                
                                Text("Register")
                                    .foregroundColor(.black)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(20)
                            }
                        }
                    
                        
                        CreateText(label: loginResult, size: 15, weight: .light)
                        
                        
                    }
                }
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

struct CreateText: View {
    
    var label: String
    var size: Double
    var weight: Font.Weight = .light
    var color: Color = .blue
    var design: Font.Design = .default
    
    var body: some View {
        Text(label)
            .font(.system(size:size, weight: weight, design: design))
            .foregroundColor(color)
    }
}

struct CreateTextField: View {
    
    var text: String
    var inputText: Binding<String>
    
    var body: some View {
        TextField(text, text: inputText)
            .multilineTextAlignment(.center)
            .textFieldStyle(.roundedBorder)
            .padding()
    }
}

struct CreateSecureField: View {
    
    var text: String
    var inputText: Binding<String>
    
    var body: some View {
        SecureField(text, text:inputText)
            .multilineTextAlignment(.center)
            .textFieldStyle(.roundedBorder)
            .padding()
    }
}

class UserSession {
    var password = ""
    var firstName = ""
    var lastName = ""
    var userName = ""
    var email = ""
    
    func signInWithEmail() async -> String {
            do {
               try await AuthService.shared.signInEmail(email: email, password: password)
                return "success"
            } catch {
                return "incorrect login details"
            }
    }
    
    func signUpWithEmail() async -> String {
            do {
               try await AuthService.shared.registerEmail(email: email, password: password,
                                                          firstName: firstName, lastName: lastName)
                return "success"
            } catch {
                return "\(error.localizedDescription)"
            }
    }
}
