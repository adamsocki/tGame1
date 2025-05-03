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
    @ObservedObject var uiManager: UIManager
    
    init() {
        let gm = GameManager()
        _gameManager = StateObject(wrappedValue: gm)
        _uiManager = ObservedObject(wrappedValue: gm.uiManager)
    }
    
    //    @State private var multiSelection = Set<UUID>()
    
//    @State private var selectedIconType: UnitType? = .person
    
    @State private var showNewItemSheet: Bool = false
    @State private var showItemInspector: Bool = true
    @State private var didAppear = false
    
    @State private var showMainSheetView: Bool = false
    @State private var mainSheetViewDialogText: String?
    
    @State private var mainSheetColor : Color = .clear
    @State private var cursorOverMainSheet: Bool = false
    
    let selectedColor: Color = .blue
    
    var body: some View {
        NavigationSplitView {
            SidebarView(selectedItem: $selectedItem, uiManager: gameManager.uiManager,/*selectedUnitType: $gameManager.uiManager.currentUnitTypeSelected,*/ )
        } detail: {
            ConsoleAndDetailView(selectedItem: $selectedItem, gameManager: gameManager)
        }
        .inspector(isPresented: $showItemInspector) {
            ItemInspectorView(showItemInspector: $showItemInspector)
        }
        .onReceive(gameManager.uiManager.$isSheetPresented) { newValue in
            showMainSheetView = newValue
        }
        .sheet(isPresented: $showMainSheetView, onDismiss: {
            NotificationCenter.default.post(name: .uiSheetDidDismiss, object: nil)
            //            print("Here!")
        }) {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text(gameManager.uiManager.currentDialogNode?.text ?? "")
                        .padding()
                    Spacer()
                }
                Spacer()
            }
           
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(mainSheetColor)
            .contentShape(Rectangle())
            .onTapGesture {
                gameManager.dialogManager.advanceDialog()
                print("TAP")
            }
            .onHover { isHovering in
//               cursorOverMainSheet = isHovering
                
            }
            .interactiveDismissDisabled()
            
        }
        
        
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
