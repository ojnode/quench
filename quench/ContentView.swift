//  ContentView.swift
//  quench
//
//  Created by prince ojinnaka on 21/04/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State var userSession = UserSession()
    
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
                            userSession.signInWithEmail()
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
                        Spacer()
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
    
    func signInWithEmail() {
        Task {
            do {
               try await AuthService.shared.signInEmail(email: email, password: password)
            } catch {
                print(error.localizedDescription)
            }
        }
        print(email)
    }
    
    func signUpWithEmail() {
        Task {
            do {
               try await AuthService.shared.registerEmail(email: email, password: password, firstName: firstName, lastName: lastName)
            } catch {
                print(error.localizedDescription)
            }
        }
        print("check :\(password)")
    }
}
