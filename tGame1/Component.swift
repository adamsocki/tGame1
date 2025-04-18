//
//  Component.swift
//  tGame1
//
//  Created by Adam Socki on 4/19/25.
//


import Foundation
import SwiftData


@Model
final class Component {
    var name: String = ""
    
    init (name: String) {
        self.name = name
    }
}
