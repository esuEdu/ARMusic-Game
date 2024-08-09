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
    var instrument: Instruments
    
    init(instrument: Instruments) {
        self.instrument = instrument
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    func addOutlineComponent() {
        let outLineComponent = OutlineComponent(isOutlined: true)
        children[0].addChild(OutlineEntity(entity: children[0] as! HasModel))
        children[0].components.set(outLineComponent)
    }
    
    func changeOutlineComponent() {
        if var component = self.components[OutlineComponent.self] as? OutlineComponent {
            if component.isOutlined {
                component.isOutlined = false
            }else {
                component.isOutlined = true
            }
            self.components.set(component)
        }
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
