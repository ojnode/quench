//  ContentView.swift
//  quench
//
//  Created by prince ojinnaka on 21/04/2024.
//

import SwiftUI

struct ContentView: View {
    
    @State var userSession = UserSession()
    @State var logSuccessful: Bool = false
    @State var logError: String = ""
    @EnvironmentObject var BMIClass: AccessUserAttributes
    
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
                            Task { do {
                                logSuccessful = try await userSession.signInWithEmail()
                                hideKeyboard()
                            } catch let error as LogStatusError {
                                if case let .authorizationDenied(string) = error {
                                    logError = string
                                    logSuccessful = false
                                    }
                                }
                            }
                            
                        }
                        .navigationDestination(isPresented: $logSuccessful) {
                            HomeView().environmentObject(BMIClass)
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
                        if !(logSuccessful) {
                            CreateText(label: "\(logError)", size: 15, weight: .light, color: .red)
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

struct CreateImageView: View {

    var image: String
    var width: Double
    var height: Double
    var radius: Double
    var frameWidth: CGFloat?
    var frameHeight: CGFloat?

    var body: some View {
        Image(image)
            .resizable()
            .aspectRatio(CGSize(width: width, height: height), contentMode: .fit)
            .frame(width:frameWidth ?? nil, height: frameHeight ?? nil)
            .cornerRadius(radius)
    }
}

struct CreateEntryField: View {

    var label: String
    var text: Binding<String>
    var secure: Bool = false
    
    var body: some View {
        
        HStack {
            CreateText(label: label, size: 20, weight: .medium)
            if !(secure) {
                CreateTextField(text: "Enter your \(label)", inputText: text)
            } else {
                CreateSecureField(text: "Enter your \(label)", inputText: text)
            }
        }
    }
}
