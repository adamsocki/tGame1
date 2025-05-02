//
//  UIManager.swift
//  tGame1
//
//  Created by Adam Socki on 4/27/25.
//


protocol UIProvider {
    func showSheet(contentID: String, completion: @escaping () -> Void)
}

import SwiftUI

class UIManager: ObservableObject, UIProvider, DialogPresenter {
    
    
    //    @Published var currentDialogNode: DialogNode? = nil
    
    
    // *** SHEET DATA *** //
    @Published var isSheetPresented: Bool = false
    @Published var currentSheetContentId: String? = nil// Example for sheet content ID
    private var sheetCompletionHandler: (() -> Void)?
    
//    init() {
//        isSheetPresented = false
//    }
    
    func showSheet(contentID: String, completion: @escaping () -> Void) {
        print("UIManager: Request to show sheet for content: \(contentID)")
        
        guard !isSheetPresented else {
            print("UIManager: Warning - Tried to show sheet while one was already presented via sequence.")
            completion() // Call completion immediately so sequence isn't stuck
            return
        }
        
        
        self.currentSheetContentId = contentID
        self.sheetCompletionHandler = completion
        //        self.isSheetPresented = true
        DispatchQueue.main.async {
            self.isSheetPresented = true
            print("UIManager: Set isSheetPresented = true on main thread")
        }
    }
    
    
}
