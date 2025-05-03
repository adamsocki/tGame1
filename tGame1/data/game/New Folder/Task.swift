//
//  Task.swift
//  tGame1
//
//  Created by Adam Socki on 4/25/25.
//



import Foundation

//enum GameTask: String, CaseIterable, Hashable, Codable {
//    
//    // questA
//    case taskA = "start1"
//    case taskB = "start2"
//    
//    // questB
//    case taskC = "Do Task C"
//    case taskD = "Do Task D (Another State)"
//    
//}


//struct Task2: Identifiable {
//    let id = UUID
//    
//    
//    init(data: TaskData)
//    {
//        self.id = data.id
//    }
//}

struct Task: Identifiable {
    let id: Int
    let description: String
    let type: String
    let target: String?
    let quantity: Int?
    
    init(data: TaskData)
    {
        self.id = data.id
        self.description = data.description
        self.type = data.type
        self.target = data.target
        self.quantity = data.quantity
        
    }
    
   
}
