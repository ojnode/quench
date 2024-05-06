//
//  setGoals.swift
//  quench
//
//  Created by prince ojinnaka on 06/05/2024.
//


import SwiftUI

struct SetGoal: View {
    
    var body: some View {
        ZStack {
            Text("checking")
        }
    }
}

#Preview {
    SetGoal()
        .modelContainer(for: Item.self, inMemory: true)
}
