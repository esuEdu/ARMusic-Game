//
//  InstrumentSystem.swift
//
//
//  Created by Erick Ribeiro on 28/07/24.
//

import RealityKit
import Combine

public class InstrumentSystem: ObservableObject {
    public var arView: ARView?
    @Published public var instrumentEntities: [Entity] = []
    
    public init(arView: ARView?) {
        self.arView = arView
    }
    
    public func addInstrument(_ instrument: Instrument) {
        guard let arView = arView else { return }
        
        InstrumentModelManager.load(name: instrument.modelName) { entity in
            guard let loadedEntity = entity else {
                print("Failed to load the piano model.")
                return
            }
            
            let anchorEntity = AnchorEntity()
            anchorEntity.addChild(loadedEntity)
            
            // Define uma posição aleatória para o anchor entity
            let randomX = Float.random(in: -1...1)
            let randomY = Float.random(in: 0...1)
            let randomZ = Float.random(in: -1...1)
            anchorEntity.position = [randomX, randomY, randomZ]
            
            arView.scene.anchors.append(anchorEntity)
            self.instrumentEntities.append(loadedEntity)
        }
    }
    
    public func playNoteOnInstrument(_ instrumentEntity: Entity, note: Note) {
        //        let audioComponent = AudioComponent(entity: instrumentEntity, audioFile: note.audioFile)
        //        instrumentEntity.components[AudioComponent.self] = audioComponent
        //        audioComponent.play()
    }
}
