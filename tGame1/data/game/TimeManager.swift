//
//  TimeManager.swift
//  tGame1
//
//  Created by Adam Socki on 5/8/25.
//

import Foundation


class TimeManager {
    
    let timer = Timer.publish(every: 0.017, on: .main, in: .common).autoconnect()
    var lastUpdateTime: Date = Date()
    var frameCount: Int = 0
    var deltaTime: TimeInterval = 0.0
    
    private let personManager  : PersonManager
    
    init (personManager: PersonManager)
    {
        self.personManager = personManager
    }
    
    func UpdateTimeManager()
    {
        let currentTime: Date = Date()
        deltaTime = currentTime.timeIntervalSince(lastUpdateTime)
        lastUpdateTime = currentTime
        print("update Tick")
        print("deltaTime: \(deltaTime)")
        frameCount += 1
        print("frameCount: \(frameCount)")
        
        personManager.UpdatePersonManager()
    }
    
}
