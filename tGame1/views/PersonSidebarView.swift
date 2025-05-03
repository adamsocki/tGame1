//
//  PersonSidebarView.swift
//  tGame1
//
//  Created by Adam Socki on 4/23/25.
//

import SwiftUI
import SwiftData


struct PersonSidebarListView: View {
    
    
    var body: some View {
       
    }
}



struct PersonSidebarView : View {
    @Environment(\.modelContext) private var modelContext
    @Query private var persons: [PersonData]
    
    @ObservedObject var uiManager: UIManager
    
    var body: some View {
        List(selection: $uiManager.currentPersonSelected) {
            ForEach(persons) { person in
                NavigationLink(value: person) {
                    HStack {
                        Image(systemName: "person.crop.circle")
                        Text(" \(person.name)")
                        Spacer()
                    }
                    .padding()
                }
                .contextMenu {
                    Button(action: {
                        deletePerson(personToDelete: person)
                    }, label: {
                        Label("Delete Person", systemImage: "minus")
                    })
                }
            }
            
            
            Spacer()
        }
        .contextMenu {
            Button(action: {
                addPerson()
            }, label: {
                Label("Add Person", systemImage: "plus")
            })
           
        }
    }
    
    private func addPerson() {
        withAnimation {
            let newPerson = PersonData(age: 0, name: "name1")
            modelContext.insert(newPerson)
//            selectedPerson = newPerson
        }
    }
    
    private func deletePerson(personToDelete: PersonData) {
        withAnimation {
            modelContext.delete(personToDelete)
        }
    }

    
}
