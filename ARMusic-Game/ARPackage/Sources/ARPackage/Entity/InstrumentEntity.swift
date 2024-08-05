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

public class InstrumentEntity: Entity, HasModel, HasCollision {
    var instrument: Instruments!
    
    init(instrument: Instruments, modelComponent: ModelComponent) {
        self.instrument = instrument
        super.init()
       

        
       
        
        components.set(modelComponent)
        
        addAudioComponent()
        addCollisionComponent()
        addOutline()
        
    }
    
    public override func didClone(from source: Entity) {
        
        self.transform.scale = simd_float3(x: 0.01, y: 0.01, z: 0.01)
        
    }
    
    
    
    public static func fromModelEntity(_ modelEntity: ModelEntity, instrument: Instruments) -> InstrumentEntity {
        
        
        guard let model = modelEntity.model else {
            fatalError("Model Entity has no model")
            
        }
        
        let instrumentEntity = InstrumentEntity(instrument: instrument, modelComponent: model)
        
       return instrumentEntity
    }
    
    required init() {
        super.init()
    }
    
    
    
    func addOutline() {
        
        let outlineEntity = OutlineEntity(entity: self)
        
        addChild(outlineEntity)
        
    }
    
    func addAudioComponent() {
        let audioComponent = AudioComponent(instrument: instrument)
        self.components.set(audioComponent)
    }
    
    func addCollisionComponent() {
        self.generateCollisionShapes(recursive: true)
    }
    
    public func hasAudioComponent() -> Bool {
        return self.components[AudioComponent.self] != nil
    }
    
    public func changeAudioComponent(tempo: Set<Int>? = nil, note: Notes? = nil, tom: Float? = nil, startBeat: Int? = nil, endBeat: Int? = nil) {
        guard var audioComponent = self.components[AudioComponent.self] as? AudioComponent else { return }
        
        tempo?.forEach { audioComponent.tempo.toggleValue(at: $0) }
        if let note = note { audioComponent.note = note }
        if let tom = tom { audioComponent.tom = tom }
        if let startBeat = startBeat { audioComponent.startBeat = startBeat }
        if let endBeat = endBeat { audioComponent.endBeat = endBeat }
        
        self.components.set(audioComponent)
    }
    
    public func getArrayOfTempo() -> [Bool] {
        guard let audioComponent = self.components[AudioComponent.self] as? AudioComponent else {
            return []
        }
        return audioComponent.tempo.getArray()
    }
}
