//  ContentView.swift
//  quench
//
//  Created by prince ojinnaka on 21/04/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State var signInModel = SignInViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
    
                VStack (spacing: 30) {
                    
                        Text("Quench")
                            .font(.system(size:70, weight: .medium))
                            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                        Text("One day at a time")
                            .font(Font.custom("Papyrus", size: 20))
                            .foregroundColor(Color("mottoColor"))
                        Spacer()

                        TextField("Enter your username or email", text:$signInModel.email)
                            .multilineTextAlignment(.center)
                            .textFieldStyle(.roundedBorder)
                            .padding()
                        SecureField("Password", text:$signInModel.password)
                            .multilineTextAlignment(.center)
                            .textFieldStyle(.roundedBorder)
                            .padding()
                        Button("Sign In") {
                            signInModel.signInWithEmail()
                        }
                        .buttonStyle(AllButtonStyle())
                    
                        NavigationLink(destination: RegisterView().navigationBarBackButtonHidden(true)){
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

class SignInViewModel {
    var email = ""
    var password = ""
    var firstName = ""
    var lastName = ""
    
    func signInWithEmail() {
        Task {
            do {
               try await AuthService.shared.signInEmail(email: email, password: password)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func signUpWithEmail() {
        Task {
            do {
               try await AuthService.shared.registerEmail(email: email, password: password, firstName: firstName, lastName: lastName)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
}
