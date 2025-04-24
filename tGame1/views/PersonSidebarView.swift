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
    
    @Binding var selectedPerson: PersonData?
    
    var body: some View {
        List(selection: $selectedPerson) {
            ForEach(persons) { person in
                NavigationLink(value: person) {
                    HStack {
                        Image(systemName: "person.crop.circle")
                        Text(" \(person.name)")
                        Spacer()
                    }
                    .padding()
                }
            }
            
            Spacer()
        }
       
        
        
    }
    
}
