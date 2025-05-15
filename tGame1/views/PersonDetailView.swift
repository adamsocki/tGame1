//
//  PersonDetailView.swift
//  tGame1
//
//  Created by Adam Socki on 5/3/25.
//

import Foundation
import SwiftUI
import SwiftData
import Charts


struct PersonDetailView: View {
    @ObservedObject var uiManager: UIManager
    @Environment(\.modelContext) private var modelContext
    @Query private var gameDatas: [GameData]
    
    private func getChartData(for person: PersonData?) -> [PersonChartData] {
        guard let currentPerson = person else {
            return []
        }
        
        var dataPoints: [PersonChartData] = []
        
        if let energyValue = currentPerson.energy {
            dataPoints.append(PersonChartData(category: "Energy", value: energyValue))
        }
        if let hungerValue = currentPerson.hunger {
            dataPoints.append(PersonChartData(category: "Hunger", value: hungerValue))
        }
        // to add more stats here in the same way
        // if let thirstValue = currentPerson.thirst {
        //     dataPoints.append(PersonChartData(category: "Thirst", value: thirstValue))
        // }
        
        return dataPoints
    }
    struct PositionComponentData: Identifiable {
        let id = UUID()
        var axis: String // "X", "Y", or "Z"
        var value: Float
        var type: String // To group them if you plot multiple people's positions
    }
    private func getPositionChartData(for person: PersonData?) -> [PositionComponentData] {
        guard let pos = person?.position else { return [] }
        return [
            PositionComponentData(axis: "X", value: pos.x, type: person?.name ?? "Position"),
            PositionComponentData(axis: "Y", value: pos.y, type: person?.name ?? "Position"),
            PositionComponentData(axis: "Z", value: pos.z, type: person?.name ?? "Position")
        ]
    }


    
    var body: some View {
        
        if let personSelected = uiManager.currentPersonSelected {
//            print("Person Selected: \(personSelected)")
            
            let chartData = getChartData(for: personSelected)
            let positionData = getPositionChartData(for: personSelected) // from option 1

            
            VStack {
                HStack {
                    
                    
                    Text("Person Name: \(personSelected)")
                    Button(action: {
                        personSelected.position!.y += 1
                    }, label: {
                        Text("Forward")
                        
                    })
                    Text("Person Position: \(personSelected.position!.x), \(personSelected.position!.y), \(personSelected.position!.z)")
                    Spacer()
                    
                }
                .padding()
                VStack{
                    HStack{
                        Text("Energy: \(personSelected.energy ?? 0.0, specifier: "%.2f")")
                        
                        Spacer()
                    }
                    HStack{
//                        Chart(chartData)
//                        { item in
//                            BarMark(
//                                x: .value("Categoy", item.category),
//                                y: .value("Value", item.value)
//                            )
//                            .foregroundStyle(by: .value("Statistic", item.category))
//                            .cornerRadius(6)
//                            
//                        }.frame(width: 100, height: 100)
//                            .labelsHidden()
//                        Spacer()
                        Button(action: {
                            personSelected.EnergyBump(val: 1)
                        }, label :  {
                            Text("Energy Boost")
                        })
                        Spacer()
                    }
                    
                    
//                    Chart(positionData) { component in
//                        BarMark(
//                            x: .value("Axis", component.axis),
//                            y: .value("Value", component.value)
//                        )
//                        .foregroundStyle(by: .value("Axis", component.axis)) // Different color for X, Y, Z
//                    }
//                    .chartYAxisLabel("Coordinate Value")
//                    .frame(height: 200)
//
                    
                   
//                    if let pos = personSelected.position {
//                        VStack(alignment: .leading) {
//                            Text("2D Position (X-Y) with Z-depth")
//                                .font(.headline)
//                            Chart {
//                                // RuleMark for origin lines
//                                RuleMark(x: .value("OriginX", 0))
//                                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [3]))
//                                    .foregroundStyle(.gray.opacity(0.5))
//                                RuleMark(y: .value("OriginY", 0))
//                                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [3]))
//                                    .foregroundStyle(.gray.opacity(0.5))
//                                
//                                PointMark(
//                                    x: .value("X Coordinate", pos.x),
//                                    y: .value("Y Coordinate", pos.y)
//                                )
//                                // Encode Z-axis with point size (adjust scale as needed)
//                                .symbolSize(by: .value("Z Coordinate", abs(pos.z))) // abs() if size shouldn't be negative
//                                // Or Encode Z-axis with color
//                                .foregroundStyle(Color(hue: Double(normalize(pos.z, minZ: -50, maxZ: 50)), // Example normalization
//                                                       saturation: 0.8, brightness: 0.8))
//                                .annotation(position: .overlay, alignment: .center) {
//                                    Text("Z: \(pos.z, specifier: "%.1f")")
//                                        .font(.caption)
//                                        .foregroundColor(.white) // Adjust color for contrast
//                                        .padding(3)
//                                        .background(Color.black.opacity(0.5))
//                                        .clipShape(Capsule())
//                                }
//                            }
//                            .chartXAxisLabel("X Axis")
//                            .chartYAxisLabel("Y Axis")
//                            // Define appropriate domains if your coordinates can vary widely
//                            // .chartXScale(domain: -100...100)
//                            // .chartYScale(domain: -100...100)
//                            .aspectRatio(1, contentMode: .fit) // Make it square for better spatial sense
//                            .frame(height: 300)
//                        }
//                    }
//                    Chart(positionData) { component in
//                                BarMark(
//                                    x: .value("Value", component.value), // Value on X-axis for horizontal bars
//                                    y: .value("Axis", component.axis)    // Axis category on Y-axis
//                                )
//                                .foregroundStyle(by: .value("Axis", component.axis))
//
//                                // Add a zero line
//                                RuleMark(x: .value("Origin", 0))
//                                    .lineStyle(StrokeStyle(lineWidth: 1))
//                                    .foregroundStyle(.black)
//                            }
//                            .chartXAxisLabel("Deviation")
//                            .frame(height: 150)
//                    
                }
                
                
                .padding()
                
                
                Spacer()
                
            }
        }
        
       
    }
    
    func normalize(_ value: Float, minZ: Float, maxZ: Float) -> Float {
               guard maxZ != minZ else { return 0.5 } // Avoid division by zero
               return max(0, min(1, (value - minZ) / (maxZ - minZ)))
           }
}
//
//let samplePerson1 = PersonData(age: 30, name: "Alex Ranger")
//let samplePerson2 = PersonData(age: 25, name: "Beth Codes") // Hunger is nil
//let samplePerson3 = PersonData(age: 40, name: "Chris Stats") // No stats, no position
//
//// Mock UIManager instances for different preview states
//let uiManagerWithPerson = UIManager()
//let uiManagerWithPartialStatsPerson = UIManager()
//let uiManagerWithNoStatsPerson = UIManager()
//let uiManagerNoPerson = UIManager()
//
//
//// The #Preview macro is the modern way to do previews (Xcode 15+)
//#Preview("Alex (Full Stats)") {
//    // For SwiftData @Model classes, you need a model container in the preview
//    PersonDetailView(uiManager: uiManagerWithPerson)
//        .modelContainer(for: [PersonData.self, GameData.self], inMemory: true) { result in
//            // You can optionally insert sample data into the in-memory store here if your
//            // view's @Query depends on it, or if PersonData instances need to be fetched.
//            // For this UIManager setup, direct injection of PersonData is often enough.
//            // Example:
//            // switch result {
//            // case .success(let container):
//            //     let context = container.mainContext
//            //     context.insert(samplePerson1) // If Alex should be from the context
//            // case .failure(let error):
//            //     fatalError("Failed to create model container for preview: \(error.localizedDescription)")
//            // }
//        }
//}
//
//#Preview("Beth (Partial Stats)") {
//    PersonDetailView(uiManager: uiManagerWithPartialStatsPerson)
//        .modelContainer(for: [PersonData.self, GameData.self], inMemory: true)
//}
//
//#Preview("Chris (No Stats)") {
//    PersonDetailView(uiManager: uiManagerWithNoStatsPerson)
//        .modelContainer(for: [PersonData.self, GameData.self], inMemory: true)
//}
//
//#Preview("No Person Selected") {
//    PersonDetailView(uiManager: uiManagerNoPerson)
//        .modelContainer(for: [PersonData.self, GameData.self], inMemory: true) // Still need container if Query is present
//}
