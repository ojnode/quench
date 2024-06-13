//  ContentView.swift
//  quench
//
//  Created by prince ojinnaka on 21/04/2024.
//

import SwiftUI

struct ContentView: View {
    @State var userSession = UserSession()
    @State var sessionResult = (false, "")
    
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
                                sessionResult = await userSession.signInWithEmail()
                                hideKeyboard()
                            }
                            
                        }
                        .navigationDestination(isPresented: $sessionResult.0) {
                            HomeView()
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
                        if !(sessionResult.0) {
                            CreateText(label: "\(sessionResult.1)", size: 15, weight: .light, color: .red)
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
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}

// cant be done without UIKIT
func hideKeyboard() {
    #if canImport(UIKit)
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    #endif
}

struct AllButtonStyle: ButtonStyle {

  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
      .padding()
      .foregroundColor(.black)
      .background(configuration.isPressed ? Color("button") : Color.blue)
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

struct UserSession {
    var password = ""
    var firstName = ""
    var lastName = ""
    var userName = ""
    var email = ""
    
    func signInWithEmail() async -> (Bool, String) {
            do {
               try await AuthService.shared.signInEmail(email: email, password: password)
                return (true, "")
            } catch {
                return (false, "\(error.localizedDescription)")
            }
    }
    
    func signUpWithEmail() async -> (Bool, String) {
            do {
               try await AuthService.shared.registerEmail(email: email, password: password,
                                                          firstName: firstName, lastName: lastName)
                return (true, "")
            } catch {
                return (false, "\(error.localizedDescription)")
            }
    }
}
