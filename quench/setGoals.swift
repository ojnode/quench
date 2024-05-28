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
                    
                    CreateEntryField(label: "Age", text: $age)
                
                    CreateEntryField(label: "Weight", text: $weight)
                
                    CreateEntryField(label: "Height", text: $height)
                
                    CreateEntryField(label: "Gender", text: $gender)
                
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

struct CreateEntryField: View {
    
    var label: String
    var text: Binding<String>
    var secure: Bool = false
    
    var body: some View {
        
        HStack {
            CreateText(label: label, size: 20, weight: .medium)
            if !(secure) {
                CreateTextField(text: "Enter your \(label)", inputText: text)
            } else { CreateSecureField(text: "Enter your \(label)", inputText: text)
            }
        }
    }
}


enum valueError: Error {
    case weightError
    case heightError
    case ageError
}
