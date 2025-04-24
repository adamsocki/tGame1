//
//  Person.swift
//  tGame1
//
//  Created by Adam Socki on 4/23/25.
//

import Foundation
import SwiftData

@Model
final class PersonData {
    var age: Int
    var name: String
    
    init (age: Int, name: String) {
        self.age = age
        self.name = name;
    }
}
