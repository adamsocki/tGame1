//
//  tGame1App.swift
//  tGame1
//
//  Created by Adam Socki on 4/17/25.
//

import SwiftUI
import SwiftData

@main
struct tGame1App: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            ItemData.self,
            GameData.self,
            PersonData.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            let newGameData = GameData(score: 0)
            
            container.mainContext.insert(newGameData)
//            let newPerson_1 = PersonData(age: 37, name: "Adam Socki")
//            container.mainContext.insert(newPerson_1)
            
            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
