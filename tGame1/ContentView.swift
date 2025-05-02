//
//  ContentView.swift
//  tGame1
//
//  Created by Adam Socki on 4/17/25.
//

import SwiftUI
import Foundation
import SwiftData



struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [ItemData]
    
    @State var selectedItem: ItemData?
    @State var selectedPerson: PersonData?
    
    //    @StateObject private var progressionManager = ProgressionManager()
    //    @StateObject private var dialogManager = DialogManager()
    
    @StateObject private var gameManager = GameManager()
    
    //    @State private var multiSelection = Set<UUID>()
    
    @State private var selectedIconType: IconType? = .house
    
    @State private var showNewItemSheet: Bool = false
    @State private var showItemInspector: Bool = true
    @State private var didAppear = false
    
    @State private var showMainSheetView: Bool = false
    
    let selectedColor: Color = .blue
    
    var body: some View {
        NavigationSplitView {
            SidebarView(selectedItem: $selectedItem, selectedIconType: $selectedIconType, selectedPerson: $selectedPerson)
        } detail: {
            ConsoleAndDetailView(selectedItem: $selectedItem, gameManager: gameManager)
        }
        .inspector(isPresented: $showItemInspector) {
            ItemInspectorView(showItemInspector: $showItemInspector)
        }
        .onAppear {
            // Run only once when the view appears
//            if !didAppear {
//                print("ContentView appeared. Starting intro scene...")
////                gameManager.sceneManager.startScene(id: "intro_scene") {
//                    print("ContentView: Intro scene completed.")
//                }
//                didAppear = true // Set flag so it doesn't run again
//            }
        }
        .onReceive(gameManager.uiManager.$isSheetPresented) { newValue in
            showMainSheetView = newValue
        }
        .sheet(isPresented: $showMainSheetView, onDismiss: {
            NotificationCenter.default.post(name: .uiSheetDidDismiss, object: nil)
            print("Here!")
        }) { /*item in*/
            //            SheetContainerView(itemID: item.id)
            //                .environmentObject(gameManager.uiManager)
            //            SheetContainerView()
            //                        .environmentObject(gameManager.uiManager)
            Text("test")
        }
        
        
        
        
//            .onReceive(gameManager.uiManager.$isSheetPresented) { newValue in
//                 print("ContentView (Simplified) .onReceive: isSheetPresented changed to \(newValue)")
//            }
        
        //        .sheet(isPresented: $gameManager.uiManager.isSheetPresented, onDismiss: {
        ////            NotificationCenter.default.post(name: .gameStarted, object: nil)
        //        }, content: {
        ////            MainSheetView(gameManager: gameManager, dialogManager: gameManager.dialogManager, showMainSheetView: $showMainSheetView)
        //
        //        })
    }
    
    private func deleteItem(itemToDelete: ItemData) {
        modelContext.delete(itemToDelete)
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            let itemsToDelete = offsets.map { items[$0] }
            for itemToDelete in itemsToDelete {
                if itemToDelete == selectedItem {
                    selectedItem = nil
                }
                modelContext.delete(itemToDelete) // Delete from context
            }
        }
    }
}
