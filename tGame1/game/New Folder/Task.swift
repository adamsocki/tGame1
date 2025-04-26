//
//  Task.swift
//  tGame1
//
//  Created by Adam Socki on 4/25/25.
//



import Foundation

enum GameTask: String, CaseIterable, Hashable, Codable {
    
    // questA
    case taskA = "start1"
    case taskB = "start2"
    
    // questB
    case taskC = "Do Task C"
    case taskD = "Do Task D (Another State)"
    
}

struct Task: Identifiable {
    let id: GameTask
    let description: String
    
    
    init (id: GameTask, description: String) {
        self.id = id
        self.description = description

    }
    
    func makeTask() {
        
    }
}
