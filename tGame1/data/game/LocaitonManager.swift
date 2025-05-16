//
//  LocaitonManager.swift
//  tGame1
//
//  Created by Adam Socki on 5/14/25.
//


import SwiftUI
import Charts


struct LocationCell
{
    var positive: String
    var negative: String
    var num: Double
    
//    var data: LocationCellData = LocationCellData()
    

    
}



struct LocationCellData
{
    init()
    {
        
    }
}

struct Location: Identifiable
{
    
    let id = UUID()
    let count: Int
    let startx: Double
    let endx: Double
    let starty: Double
    let endy: Double
//    var locationCells: [LocationCell] {
//        [LocationCell(positive: "-", negative: "1", num: 3)]
//    }
//    locationCells
    
    
    static func generate() -> [Location] {
        let cellWidth: Double = 10.0   // Example width for each cell
        let cellHeight: Double = 10.0  // Example height for each cell
        
        var locationCells: [Location] = []
        for x in 0..<30 {
            for y in 0..<30 {
                let currentCount = x + y
                let startx: Double = Double(x) * cellWidth
                let endx: Double = startx + cellWidth
                let starty: Double = Double(y) * cellHeight
                let endy: Double = starty + cellHeight
                locationCells.append(Location(count: Int.random(in: 0...35), startx: startx, endx: endx, starty: starty, endy: endy))
             
            }
//              locationCells.append(Location(positive: "-", negative: "1", num: Double.random(in: 0...100)))
        }
        return locationCells
        
        
        
    }
}


struct LocationView : View
{
    
    var locationData2: [Location] = Location.generate()
    
    var body: some View {
        
        
        
        
        
        Chart(locationData2) { location in
            RectangleMark(
                xStart: .value("Start week", location.startx),
                xEnd: .value("End week", location.endx),
                yStart: .value("Start weekday", location.starty),
                yEnd: .value("End weekday", location.endy)
            )
            .foregroundStyle(by: .value(" Number", location.count))
        }
//        .frame(minWidth: 10,minHeight: 10)
    }
}


#Preview {
    
    LocationView()
        
}



struct LocationManager
{
    
    
    func InitLocationManager()
    {
        
    }
    
    func UpdateLocation()
    {
        
    }
    
}
