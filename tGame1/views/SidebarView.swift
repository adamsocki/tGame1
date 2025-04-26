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
    @Binding var selectedIconType: IconType?
    
    
    @Binding var selectedPerson: PersonData?
    
    
    let selectedColor: Color = .blue
    
    var body: some View {
        ZStack {
            VStack {
                Divider()
                HStack {
                    ForEach(IconType.allCases) { iconType in
                        
                        Button(action: {
                            self.selectedIconType = iconType
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
                case .person:
                    PersonSidebarView(selectedPerson: $selectedPerson)
                case .house:
                    ItemSidebarView(selectedItem: $selectedItem)
                case .cat:
                    Text("Trash")
                    Spacer()
                default:
                    Text("Default")
                    Spacer()
                }
            }
        }
    }
}
