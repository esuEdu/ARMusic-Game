//
//  WorldSystem.swift
//
//
//  Created by Eduardo on 25/07/24.
//

import RealityKit
import ARKit

public class WorldSystem: System {
    public required init(scene: Scene) {
        setNoteDuration()
    }
    
    var BPM: Int = 120{
        didSet {
            setNoteDuration()
        }
    }
    
    // Note duration in milliseconds
    var noteDuration: Float = 0
    
    var currentBeat: Int = 0
    var currentNote: Int = 0
    var currentTime: TimeInterval = 0
    
    var maxBeats: Int = 0 // Maximum number of beats before resetting

    private var timer: Timer?
    
    func setNoteDuration() {
        self.noteDuration = Float(7500 / BPM)
    }
    
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(noteDuration / 1000), repeats: true) { [weak self] _ in
            self?.updateTime()
        }
    }
    
    func pauseTimer() {
        timer?.invalidate()
    }
    
    private func updateTime() {
        currentNote += 1
        if currentNote >= 8 {
            currentNote = 0
            currentBeat += 1
        }
        
        print("Current Beat: \(currentBeat), Current Note: \(currentNote)")
    }
}
