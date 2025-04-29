//
//  UIManager.swift
//  tGame1
//
//  Created by Adam Socki on 4/27/25.
//


protocol UIProvider {
    func showDialog(dialogID: String, completion: @escaping () -> Void)
    func showSheet(contentID: String, completion: @escaping () -> Void)
    
}

import SwiftUI

class UIManager: ObservableObject, UIProvider {
    @Published var isSheetPresented: Bool = false
    
//    @EnvironmentObject var uiManager: UIManager
    
    
    @Published var isDialogPresented: Bool = false
    @Published var currentDialogId: String?
    
//    private var sequenceCompletionHandler: (() -> Void)?
    private var dialogCompletionHandler: (() -> Void)?
    
    
    
    func showSheet(contentID: String, completion: @escaping () -> Void) {
        print("UIManager: Request to show sheet for content: \(contentID)")
        
        guard !isSheetPresented else {
            print("UIManager: Warning - Tried to show sheet while one was already presented via sequence.")
            completion() // Call completion immediately so sequence isn't stuck
            return
        }
//        self.sequenceCompletionHandler = completion
        // Set the state that the SwiftUI view will react to
//        self.currentSheetContentId = contentId
        self.isSheetPresented = true
        
    }
    
    func showDialog(dialogID: String, completion: @escaping () -> Void) {
        print("UIManager: Request to show dialog: \(dialogID)")
        guard !isDialogPresented && self.dialogCompletionHandler == nil else {
            print("UIManager: Warning - Tried to show sequence dialog while one was already presented.")
            completion()
            return
        }
        self.dialogCompletionHandler = completion
        self.currentDialogId = dialogID
        self.isDialogPresented = true
    }
}
