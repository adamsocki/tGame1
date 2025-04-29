//
//  Quest.swift
//  tGame1
//
//  Created by Adam Socki on 4/25/25.
//


//enum GameQuest: String, CaseIterable {
//    case introQuest
//    
//    case firstLevel
//    
//}

import SwiftUI


struct QuestView: View {
    var body: some View {
        HStack {
            
            Text("Hello, World!")
                .contentShape(Rectangle())
        }
        .frame(width: 80, height: 60)
        .contentShape(Rectangle())
    }
        
}

enum QuestType: String, CaseIterable {
    case introQuest
    
    case firstLevel
}


//class Quest2 {
//    let id: QuestType
//    let name: String
//    let description: String
//    let tasks: [Task]
//    
//    
//    init (definition: QuestData) {
//        guard let questType = QuestType(rawValue: definition.id) else {
//            fatalError("Quest ID '\(definition.id)' in json not found in QuestType")
//        }
//        
//        self.id = questType
//        self.name = definition.name
//        self.description = definition.description
//        self.tasks = definition.tasks.map{Task(data: $0)}
//    }
//}


class Quest {
    let id: String
    var tasks: [Task] = []
    
    
    
    var view: QuestView?
    var currentTask: Task?
    var currentTaskIndex: Int = 0
//    let name: String
    
    
    init(data: QuestData) {
        self.id = data.id
//        self.name = name
        self.view = QuestView()
    }
    
    func addTask(task: Task)
    {
        tasks.append(task)
    }
    
    func startQuest() {
        
    }
    
    func completeQuest()
    {
        print("Quest completed")
        
    }
    
    func doAdvanceTask() {
        currentTaskIndex += 1
        print("doAdvanceTask")
    }
    
    
    func tryAdvanceTask() {
        if currentTaskIndex >= tasks.count {
            completeQuest()
        } else {
            doAdvanceTask()
        }
    }
}
