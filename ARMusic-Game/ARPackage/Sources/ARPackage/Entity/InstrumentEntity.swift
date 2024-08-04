//
//  File.swift
//  
//
//  Created by Erick Ribeiro on 01/08/24.
//

import Foundation
import RealityKit
import AudioPackage
import DataPackage

public class InstrumentEntity: Entity, HasModel, HasAnchoring, HasCollision {
    public var instrument: Instruments
    
    public init(instrument: Instruments) {
        self.instrument = instrument
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    public func addAudioComponent(note: Notes, tom: Float, startBeat: Int = 0, endBeat: Int = 1) {
        var audioComponent = AudioComponent(note: note, instrument: instrument, tom: tom, startBeat: startBeat, endBeat: endBeat)
        self.components.set(audioComponent)
    }
    
    public func addCollisionComponent() {
        self.generateCollisionShapes(recursive: true)
    }
    
    public func hasAudioComponent() -> Bool {
        return self.components[AudioComponent.self] != nil
    }
    
}
