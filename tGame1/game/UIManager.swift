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
    
    
    // --- Dialog Presentation State --- //
    @Published var isSheetPresented: Bool = false
    @Published var isMainSheetDialogCurrent: Bool = false
    @Published var currentSheetContentId: String? = nil// Example for sheet content ID
    private var sheetCompletionHandler: (() -> Void)?
    @Published var currentDialogNode: DialogNode? = nil
    
    private var currentDialogLocation: DialogViewLocation? = nil

    
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
    
    private func presentDialog(node: DialogNode, location: DialogViewLocation)
    {
        if currentDialogLocation != nil && currentDialogLocation != location { dismissDialog() }
                 else if currentDialogLocation == location { updateDialogContent(node: node); return }
                 self.currentDialogNode = node; self.currentDialogLocation = location
                 switch location {
                 case .main_sheet: self.isMainSheetDialogCurrent = true
//                 case .sidebar: self.isSidebarDialogActive = true
//                 case .console_left: self.isConsoleLeftDialogActive = true
                 default: print("UIManager: Presentation for \(location.rawValue) TBD"); self.currentDialogNode=nil; self.currentDialogLocation=nil;
                 }
    }
    
    
    func presentDialogInMainSheet(node: DialogNode, location: DialogViewLocation) {
        presentDialog(node: node, location: location)
    }
//    func presentDialogInSheet(node: DialogNode) { presentDialog(node: node, location: .sheet) }
        
    func dismissDialog() {
        guard let location = currentDialogLocation else {
            return
        }
        switch location {
        case .main_sheet:
            self.isMainSheetDialogCurrent = false
        default:
            return
        }
        self.currentDialogNode = nil
        self.currentDialogLocation = nil
    }
    
    func updateDialogContent(node: DialogNode) { /* ... from previous */
        guard currentDialogLocation != nil else { return }
        self.currentDialogNode = node
    }
    
}
