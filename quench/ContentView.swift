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
        NavigationView {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                VStack (spacing: 90){
                    VStack {
                        Text("Quench")
                            .font(.system(size:70, weight: .medium))
                            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                        Text("One day at a time")
                            .font(Font.custom("Papyrus", size: 20))
                            .foregroundColor(Color("mottoColor"))
                    }
                    Spacer()
                    
                    VStack {
                        TextField("Enter your username or email", text:$signInModel.email)
                            .multilineTextAlignment(.center)
                            .frame(maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                            .textFieldStyle(.roundedBorder)
                            .padding()
                        SecureField("Password", text:$signInModel.password)
                            .multilineTextAlignment(.center)
                            .frame(maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                            .textFieldStyle(.roundedBorder)
                            .padding()
                        Button("Sign In") {
                            signInModel.signInWithEmail()
                        }
                        .buttonStyle(AllButtonStyle())
                    }
                    
                    
                    
                    
                    NavigationLink(destination: RegisterView()){
                        Text("Register")
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
