//
//  File.swift
//
//
//  Created by Eduardo on 03/08/24.
//

import Foundation
import DataPackage

extension ARViewManager {
    
    public func changeAudioComponent(tempo: Set<Int>? = nil, note: Notes? = nil, tom: Float? = nil, startBeat: Int? = nil, endBeat: Int? = nil) {
        guard let instrumentEntity = stateMachine.currentEntity as? InstrumentEntity else {
            return
        }
        instrumentEntity.changeAudioComponent(tempo: tempo, note: note, tom: tom, startBeat: startBeat, endBeat: endBeat)
    }

    public func getIndiceOfTempo() -> [Int] {
        guard let instrumentEntity = stateMachine.currentEntity as? InstrumentEntity else {
            return []
        }
        return instrumentEntity.getArrayOfTempo().enumerated().compactMap { $1 ? $0 : nil }
    }
}
