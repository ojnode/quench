//
//  user.swift
//  quench
//
//  Created by prince ojinnaka on 28/04/2024.
//

import Foundation

class User: Identifiable, Codable {
    var firstName: String
    var lastName: String
    var userName: String
    
    init(firstName: String, lastName: String, userName: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.userName = userName
    }
    
    func store() {
        print("firstname : \(firstName), lastName: \(lastName), userName: \(userName)")
    }
}
