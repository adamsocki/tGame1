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
    
//    @EnvironmentObject var uiManager: UIManager
    
    @ObservedObject var gameManager : GameManager
    @ObservedObject var dialogManager: DialogManager
    @Binding var showMainSheetView: Bool
   
    private var progressionManager: ProgressionManager {
        
        gameManager.progressionManager // Provides direct access syntax locally
    }
    
    private var progressionMapper: ProgressionMapper {
        
        gameManager.progressionMapper // Provides direct access syntax locally
    }
    
//    let dialogId: String
    var body: some View {	
        
        HStack {
            
            //            Text(
            Text(dialogManager.currentText ?? "Loading...") // Display the current text
                .id(dialogManager.currentText) // Optional: Add .id() to help SwiftUI detect changes more explicitly
                .padding() // Add some padding for better visuals
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Allow tap anywhere
        .contentShape(Rectangle())
        .onAppear {
            //            gameManager.sequenceManager.startSequence(id: "intro_sequence")
        }
        .onTapGesture {
//            gameManager.sequenceManager.processNextStep()
            gameManager.dialogManager.advanceDialog()
            debugPrint("tap")
        }
        
//        forEach(q)
        
//        switch progressionManager.currentQuest.id{
//            
//        case QuestType.introQuest:
////            try progressionManager.currentQuest.startQuest()
//            
////
////            Text("\(dialogManager.findNodeText(type: "gameVoice", part: "1", seq: "1") ?? "Not Found")")
////                .padding()
//            
//            if let questView = progressionManager.currentQuest.view {
//              
//                questView
//                    .onTapGesture {
////                        debugPrint("tap")
//                        progressionManager.currentQuest.tryAdvanceTask()
////                        progressionManager.currentQuest.tasks.count > 9 ? self.showMainSheetView.toggle() : print("No tasks to complete")
//                    }
//            } else {
//                // Provide fallback content if the view is nil
//                Text("Intro quest view not available.")
//                    .foregroundColor(.orange) // Example styling
//            }
//            
//            
//            
//        default:
//            Text("Default Quest")
//        }
           
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

