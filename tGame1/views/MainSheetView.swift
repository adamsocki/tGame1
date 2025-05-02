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
   
//    private var progressionManager: ProgressionManager {
//        
//        gameManager.progressionManager // Provides direct access syntax locally
//    }
//    
//    private var progressionMapper: ProgressionMapper {
//        
//        gameManager.progressionMapper // Provides direct access syntax locally
//    }
    
    
    var body: some View {
        
        HStack {
            Text(dialogManager.currentText ?? "Loading...")
                .id(dialogManager.currentText)
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
        .onAppear {
            //            gameManager.sequenceManager.startSequence(id: "intro_sequence")
        }
        .onTapGesture {
//            gameManager.sequenceManager.processNextStep()
            gameManager.dialogManager.advanceDialog()
            debugPrint("tap")
        }
        
    }
}

