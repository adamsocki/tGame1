//
//  ProgressionMapper.swift
//  tGame1
//
//  Created by Adam Socki on 4/25/25.
//

import Foundation
import SwiftUI


class ProgressionMapper {
    
   
    
    
    let gameTasks: [GameTask: Task] =  [
        //
        .taskA: Task(id: .taskA, description: "taskA")
    ]
    
    
    
    var gameQuests: [Quest] =  []
        
//        .introQuest: Quest(
//            id: .introQuest,
//            name: "intro quest"),
//        .firstLevel: Quest(
//            id: .firstLevel,
//            name: "first level")
//    ]
    
    
    
    init () {
        makeTasks()
        makeQuests()
        
//        let introQuest = Quest(
//                    id: .introQuest)
//        let introQView: QuestView = QuestView()
//
//        introQuest.view = introQView
        
        
//        gameQuests.append(<#T##newElement: Quest##Quest#>)
        
        // Assign Tasks to Quests
//        gameQuests[.firstLevel]?.addTask(task: gameTasks[.taskA]!)
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    private func makeTasks() {
        
        let quest_1 = Quest(id: .introQuest)
        quest_1.addTask(task: gameTasks[.taskA]!)
        
        
    }
    
    private func makeQuests() {
        
    }
    
    
    
}
