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
    @State var sex = ""
    
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
            VStack (spacing: 30) {
                HStack {
                    Text("Age")
                        .font(.system(size:20, weight: .medium))
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    TextField("Enter your password", text:$age)
                        .multilineTextAlignment(.center)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                }
                
                HStack {
                    Text("Weight")
                        .font(.system(size:20, weight: .medium))
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    TextField("Enter your password", text:$weight)
                        .multilineTextAlignment(.center)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                }
                
                HStack {
                    Text("Height")
                        .font(.system(size:20, weight: .medium))
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    TextField("Enter your password", text:$height)
                        .multilineTextAlignment(.center)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                }
                
                HStack {
                    Text("Sex")
                        .font(.system(size:20, weight: .medium))
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    TextField("Enter your password", text:$sex)
                        .multilineTextAlignment(.center)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                }
            }
        }
    }
}

#Preview {
    SetGoal()
        .modelContainer(for: Item.self, inMemory: true)
}

enum valueError: Error {
    case weightError
    case heightError
    case ageError
}
