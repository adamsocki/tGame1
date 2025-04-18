//
//  SidebarView.swift
//  tGame1
//
//  Created by Adam Socki on 4/20/25.
//



import SwiftUI
import SwiftData


struct SidebarView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    @Binding var selectedItem: Item?
    @Binding var selectedIconType: IconType?
    
    
    
    let selectedColor: Color = .blue
    
    var body: some View {
        ZStack {
//            Color.red
//                .contentShape(Rec/tangle())
//                .onTapGesture {
//                    print("tap")
//                }
            VStack {
                Divider()
                HStack {
                    ForEach(IconType.allCases) { iconType in
                        Button(action: {
                            //                        blank()
                            self.selectedIconType = iconType
                            //                        handleIconTap(iconType: iconType)
                        }, label: {
                            let labelView = Label("", systemImage: iconType.systemImageName)
                            if selectedIconType == iconType {
                                labelView
                                    .foregroundStyle(selectedColor)
                            }
                            else {
                                labelView
                            }
                        })
                        .buttonStyle(.borderless)
                        .foregroundStyle(.gray)
                    }
                }
                .padding(.horizontal, 10)
                .padding(.top, -5)
                Divider()
                    .padding(.vertical,-2)
                
                switch selectedIconType {
                case .house:
                    List(selection: $selectedItem)   {
                        ForEach(items) { item in
                            NavigationLink(value: item) {
                                
                                ItemSidebarView(item: item)
                                
                                
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
    //                                    deleteItem(itemToDelete: item)
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
                            print("RightClick")
                            addItem()
                        }, label: {
                            Label("Add Item", systemImage: "plus")
                        })
                    }
                case .cat:
                    Text("Trash")
                    Spacer()
                default:
                    Text("Default")
                    Spacer()
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
        }
        
        
    }
    
    private func deleteItem(itemToDelete: Item) {
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
    
    private func renameItem(itemToRename: Item) {
        withAnimation {
//            itemToRename.name ;
            itemToRename.sidebarViewState = ItemSidebarViewState.editingName
        }
    }
    
    
    private func addItem() {
        withAnimation {
            let newItem = Item(score: 0, timeCreated: CACurrentMediaTime(), name: "New Item")
            modelContext.insert(newItem)
            selectedItem = newItem
        }
    }
    
    
    private func deleteAllItems() {
        
        let countToDelete = items.count
        guard countToDelete > 0 else { return }
        withAnimation {
            let allItemsToDelete = Array(items)
            for item in allItemsToDelete {
                modelContext.delete(item)
            }
            
            selectedItem = nil
        }
    }
}
