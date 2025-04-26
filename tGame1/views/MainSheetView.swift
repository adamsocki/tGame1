//
//  MainSheetView.swift
//  tGame1
//
//  Created by Adam Socki on 4/24/25.
//

import Foundation

import SwiftUI

struct MainSheetView2: View {
    
    @ObservedObject var gameManager : GameManager
    @Binding var showMainSheetView: Bool
    
    var body: some View {
        Text("Hello, World!")
    }
}

struct MainSheetView: View {
    
    
    
    @ObservedObject var gameManager : GameManager
    @Binding var showMainSheetView: Bool
    private var dialogManager: DialogManager {
        
        gameManager.dialogManager // Provides direct access syntax locally
    }
    
    private var progressionManager: ProgressionManager {
        
        gameManager.progressionManager // Provides direct access syntax locally
    }
    
    private var progressionMapper: ProgressionMapper {
        
        gameManager.progressionMapper // Provides direct access syntax locally
    }
    
    
    var body: some View {
        
        
        
        
        switch progressionManager.currentQuest.id{
            
        case QuestType.introQuest:
//            try progressionManager.currentQuest.startQuest()
            
//
//            Text("\(dialogManager.findNodeText(type: "gameVoice", part: "1", seq: "1") ?? "Not Found")")
//                .padding()
            
            if let questView = progressionManager.currentQuest.view {
              
                questView
                    .onTapGesture {
//                        debugPrint("tap")
                        progressionManager.currentQuest.tryAdvanceTask()
//                        progressionManager.currentQuest.tasks.count > 9 ? self.showMainSheetView.toggle() : print("No tasks to complete")
                    }
            } else {
                // Provide fallback content if the view is nil
                Text("Intro quest view not available.")
                    .foregroundColor(.orange) // Example styling
            }
            
            
            
        default:
            Text("Default Quest")
        }
           
//        switch progressionManager.currentQuest{
//        case QuestType.id.introQuest:
//            Text("Intro Quest")
//        default:
//            Text("Default Quest")
//        }
        
        
        
//        switch progressionManager.currentGameState {
//        case .intro:
//
//            
//            Text("\(dialogManager.findNodeText(type: "gameVoice", part: "1", seq: "1") ?? "Not Found")")
//                .padding()
//            
//            Button("Start Game") {
//                showMainSheetView.toggle()
//                
//            }
//            default :
//            Text("Default")
//        }
        
        
    }
}

