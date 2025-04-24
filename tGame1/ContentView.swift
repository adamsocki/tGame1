//
//  ContentView.swift
//  tGame1
//
//  Created by Adam Socki on 4/17/25.
//

import SwiftUI
import SwiftData



struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [ItemData]
    
    @State var selectedItem: ItemData?
    @State var selectedPerson: PersonData?
    
//    @State private var multiSelection = Set<UUID>()
    
    @State private var selectedIconType: IconType? = .house
    
    @State private var showNewItemSheet: Bool = false
    @State private var showItemInspector: Bool = true
    
    
    
    let selectedColor: Color = .blue
    
    var body: some View {
        NavigationSplitView {
            SidebarView(selectedItem: $selectedItem, selectedIconType: $selectedIconType, selectedPerson: $selectedPerson)
        } detail: {
            ItemDetailView(selectedItem: $selectedItem)
        }
        .inspector(isPresented: $showItemInspector) {
            ItemInspectorView(showItemInspector: $showItemInspector)
        }
//        .foregroundStyle(.white)
    }
    

    
    private func deleteItem(itemToDelete: ItemData) {
        modelContext.delete(itemToDelete)
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            let itemsToDelete = offsets.map { items[$0] }
            for itemToDelete in itemsToDelete {
                if itemToDelete == selectedItem {
                    selectedItem = nil // Clear selection if selected item is deleted
                    //                    selectionCleared = true
                }
                modelContext.delete(itemToDelete) // Delete from context
            }
        }
    }
    
    
}

//#Preview {
//    ContentView()
//        .modelContainer(for: ItemData.self, inMemory: true)
//}
