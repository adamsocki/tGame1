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
    
    @Binding var selectedItem: ItemData?
    
    @ObservedObject var uiManager: UIManager
    @ObservedObject var gameStateManager: GameStateManager
    
    let selectedColor: Color = .blue
    
//    @Binding var selectedUnitType: UnitType?
//    @Binding var selectedPerson: PersonData?
//    @State var selectedUnitType: UnitType?
    
    var body: some View {
        ZStack {
            VStack {
                Divider()
                HStack {
                    ForEach(UnitType.allCases) { unitType in
                        
                        if (gameStateManager.activeTypes.isActive(unitType: unitType))
                        {
                            Button(action: {
                                uiManager.currentUnitTypeSelected = unitType
                            }, label: {
                                let labelView = Label("", systemImage: unitType.systemImageName)
                                if uiManager.currentUnitTypeSelected == unitType {
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
                }
                .padding(.horizontal, 10)
                .padding(.top, -5)
                Divider()
                    .padding(.vertical,-2)
                
                switch uiManager.currentUnitTypeSelected {
                case .person:
                    PersonSidebarView(uiManager: uiManager)
                case .house:
                    ItemSidebarView(selectedItem: $selectedItem)
                case .cat:
                    Text("Trash_meow")
                    Spacer()
                default:
                    Text("Default")
                    Spacer()
                }
            }
        }
    }
}
