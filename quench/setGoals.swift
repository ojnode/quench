//
//  setGoals.swift
//  quench
//
//  Created by prince ojinnaka on 06/05/2024.
//


import SwiftUI

struct SetGoal: View {
    
    @State var age = ""
    @State var weight = ""
    @State var height = ""
    @State var gender = ""
    
    func valueValidation() throws -> (age: Int, weight: Double, height: Double) {
            guard let weight = Double(weight) else {
                throw valueError.weightError
            }
            guard let height = Double(height) else {
                throw valueError.heightError
            }
            guard let age = Int(age) else {
                throw valueError.ageError
            }
        
        return (age, weight, height)
    }
    
    var body: some View {
        ZStack {
            VStack (spacing: 40) {
                    
                    UserAttributes(Label: "Age", text: $age)
                
                    UserAttributes(Label: "Weight", text: $weight)
                
                    UserAttributes(Label: "Height", text: $height)
                
                    UserAttributes(Label: "Gender", text: $gender)
                
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Text("Set Goal")
                })
                .buttonStyle(AllButtonStyle())
            }
        }
    }
}

#Preview {
    SetGoal()
        .modelContainer(for: Item.self, inMemory: true)
}

struct UserAttributes: View {
    
    var Label: String
    var text: Binding<String>
    
    var body: some View {
        HStack {
            Text(Label)
                .font(.system(size:20, weight: .medium))
                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
            TextField("Enter your \(Label)", text: text)
                .multilineTextAlignment(.center)
                .textFieldStyle(.roundedBorder)
                .padding()
        }
    }
}

enum valueError: Error {
    case weightError
    case heightError
    case ageError
}
