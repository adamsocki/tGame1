//
//  tGame1App.swift
//  tGame1
//
//  Created by Adam Socki on 4/17/25.
//\



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
            let context = container.mainContext
            
            if true {
                try context.delete(model: GameData.self)
            }
           
            
            let fetchDescriptor = FetchDescriptor<GameData>()
            let existingGameDataArray = try? context.fetch(fetchDescriptor)
            
            if let existingGameData = existingGameDataArray?.first {
                print("Existing GameData found with score: \(existingGameData.score). Persons count: \(existingGameData.persons.count)")
                _ = existingGameData.persons.count
            } else
            {
                print("No existing GameData found. Creating a new one.")
                let newGameData = GameData(score: 0) // Initialize with default values
                
                // Add default person(s) if this is a brand new game setup
                let newPerson_1 = PersonData(age: 37, name: "Adam Socki", position: Vector3(x:1, y:1, z:0))
                // context.insert(newPerson_1) // Not strictly needed if newGameData insert cascades
                newGameData.persons.append(newPerson_1)
                
                context.insert(newGameData)
                print("New GameData created and inserted.")
            }

            
            return container
//            let newGameData = GameData(score: 0)
            
//            let newPerson_1 = PersonData(age: 37, name: "Adam Socki")
//            newGameData.persons.append(newPerson_1)
            
//            container.mainContext.insert(newGameData)
//            container.mainContext.insert(newPerson_1)
            
            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView(modelContext: sharedModelContainer.mainContext)
        }
        .modelContainer(sharedModelContainer)
    }
    
    
    
   
}
