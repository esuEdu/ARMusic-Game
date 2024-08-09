//
//  File.swift
//  
//
//  Created by Eduardo on 09/08/24.
//

import Foundation

public struct BeatRange {
    public private(set) var startBeat: Int
    public private(set) var endBeat: Int

    public init(startBeat: Int, endBeat: Int) {
        self.startBeat = startBeat
        self.endBeat = endBeat < startBeat ? startBeat : endBeat
    }

    public mutating func updateBeats(startBeat: Int, endBeat: Int) {
        self.startBeat = startBeat
        self.endBeat = endBeat < startBeat ? startBeat : endBeat
    }
    
    public mutating func updateBeat(startBeat: Int) {
        self.startBeat = startBeat
    }
    
    public mutating func updateBeat(endBeat: Int) {
        self.endBeat = endBeat < startBeat ? startBeat : endBeat
    }
}

