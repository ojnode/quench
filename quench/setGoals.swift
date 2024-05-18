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
    
    var checkWeight: valueType {
        guard let weight = Double(weight) else {
            return .string("Use numbers only")
        }
        return .double(weight)
    }
    
    var checkHeight: valueType {
        guard let height = Double(height) else {
            return .string("Use numbers only")
        }
        return .double(height)
    }
    
    var checkAge: valueType {
        guard let age = Int(age) else {
            return .string("Use numbers only")
        }
        return .int(age)
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

enum valueType {
    case double(Double)
    case string(String)
    case int(Int)
}
