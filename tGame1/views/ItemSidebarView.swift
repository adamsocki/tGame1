//
//  ItemSidebarView.swift
//  tGame1
//
//  Created by Adam Socki on 4/22/25.
//

import SwiftUI
import SwiftData




struct ItemSidebarView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [ItemData]
    
    @Binding var selectedItem: ItemData?
    
    
    var body: some View {
        List(selection: $selectedItem)
        {
            ForEach(items) { item in
                NavigationLink(value: item) {
                    HStack {
                        switch item.sidebarViewState {
                            
                        case .normal:
                            Text("\(String(describing: item.name))")
                        case .editingName:
                            Text("HI")
                        default:
                            Text("issue")
                        }
                        
                        Text(", Score: \(item.score)")
                        Spacer()
                        Text("\(item.state)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .contextMenu {
                        Button(action: {
                            print("RightClick")
                            deleteItem(itemToDelete: item)
                        }, label: {
                            Label("Delete Item", systemImage: "trash")
                        })
                        Button(action: {
                            print("RightClick")
                            renameItem(itemToRename: item)
                        }, label: {
                            Label("Rename Item", systemImage: "trash")
                        })
                        Divider()
                        Button(action: {
                            print("RightClick")
                        }, label: {
                            Label("Item info", systemImage: "trash")
                        })
                    }
                    
                }
            }
            .onDelete(perform: deleteItems)
        }
        .navigationTitle("Items")
        .navigationSplitViewColumnWidth(min: 180, ideal: 200)
        .contextMenu {
            Button(action: {
                addItem()
            }, label: {
                Label("Add Item", systemImage: "plus")
            })
        }
        HStack {
            Button(action: {
                addItem()
            }, label: {
                Label("", systemImage: "plus")
            })
            .buttonStyle(.borderless)
            Spacer()
        }
        .padding(.bottom, 6)
        .padding(.leading, 7)
        
    }
    
    private func deleteItem(itemToDelete: ItemData) {
        modelContext.delete(itemToDelete)
    }
    //
    //    private func deleteItems(offsets: IndexSet) {
    //        withAnimation {
    //            let itemsToDelete = offsets.map { items[$0] }
    //            for itemToDelete in itemsToDelete {
    //                if itemToDelete == selectedItem {
    //                    selectedItem = nil // Clear selection if selected item is deleted
    //                    //                    selectionCleared = true
    //                }
    //                modelContext.delete(itemToDelete) // Delete from context
    //            }
    //        }
    //    }
    
    private func renameItem(itemToRename: ItemData) {
        withAnimation {
            //            itemToRename.name ;
            itemToRename.sidebarViewState = ItemSidebarViewState.editingName
        }
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
    private func addItem() {
        withAnimation {
            let newItem = ItemData(score: 0, timeCreated: CACurrentMediaTime(), name: "New Item")
            modelContext.insert(newItem)
            selectedItem = newItem
        }
    }

}
