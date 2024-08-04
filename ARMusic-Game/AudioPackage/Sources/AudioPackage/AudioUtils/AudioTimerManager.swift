//
//  File.swift
//  
//
//  Created by Eduardo on 31/07/24.
//

import Foundation

public class AudioTimerManager {
    static public var shared = AudioTimerManager()
    
    var timer: Timer = Timer()
    var isRunning: Bool = false
    var pausedTime: TimeInterval = 0
    
    var noteDuration = {
        Float(7500/AudioUtils.shared.BPM)
    }()
    
    var currentNote: Int = 0
    var currentBeat: Int = 0
    
    var maxBeat: Int = 0
    
    var soundPlayedForCurrentNote: Bool = false
    
    public func start() {
        if isRunning {
            return
        }
                
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(noteDuration / 1000), target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        isRunning = true
    }
    
    public func pause() {
        if !isRunning {
            return
        }
        
        timer.invalidate()
        isRunning = false
    }
    
    public func stop() {
        timer.invalidate()
        isRunning = false
        pausedTime = 0
        currentBeat = 0
        currentBeat = 0
    }
    
    @objc func updateTimer() {
        currentNote += 1
        if currentNote >= 8 {
            currentNote = 0
            currentBeat += 1
            
            if currentBeat >= maxBeat {
                currentBeat = 0
            }
        }
        soundPlayedForCurrentNote = false
        print("Current Beat: \(currentBeat), Current Note: \(currentNote)")
        
    }
}
