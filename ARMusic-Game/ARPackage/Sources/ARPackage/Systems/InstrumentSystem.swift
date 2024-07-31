//
//  InstrumentSystem.swift
//
//
//  Created by Erick Ribeiro on 28/07/24.
//

import RealityKit
import Combine
import SwiftUI

public class InstrumentSystem: ObservableObject {
    public var arView: ARView?
    @Published public var instrumentEntities: [Entity] = []
    @Published public var instruments: [Instrument] = []
    @Published public var selectedInstrument: Instrument?
    
    public init(arView: ARView?) {
        self.arView = arView
    }
    
    public func addInstrument(_ instrument: Instrument) {
        instruments.append(instrument)
        
        guard let arView = arView else { return }
        
        ModelLoader.load(intrumentName: instrument.name, modelname: instrument.modelName) { entity in
            guard let modelEntity = entity else {
                print("Failed to load the instrument model.")
                return
            }
            
            let raycastQuery = arView.makeRaycastQuery(from: arView.center, allowing: .estimatedPlane, alignment: .horizontal)
            
            if let result = arView.session.raycast(raycastQuery!).first {
                let anchorEntity = AnchorEntity(raycastResult: result)
                anchorEntity.addChild(modelEntity)
                
                modelEntity.generateCollisionShapes(recursive: true)
                arView.installGestures([.all], for: modelEntity as! HasCollision)
                
                arView.scene.anchors.append(anchorEntity)
                
                self.instrumentEntities.append(modelEntity)
            } else {
                print("Nenhum plano detectado.")
            }
        }
    }
    
    public func handleTapOnEntity(_ entity: Entity) {
        if let instrument = findInstrument(for: entity) {
            selectedInstrument = instrument
        }
    }
    
    private func findInstrument(for entity: Entity) -> Instrument? {
        let instrument = instruments.first { $0.name == entity.name }

        return instrument
    }
    
    public func setSequence(for instrumentId: UUID, sequence: Set<Int>) {
        if let index = instruments.firstIndex(where: { $0.id == instrumentId }) {
            instruments[index].sequence = sequence
        }
    }
    
    public func getSequence(for instrumentId: UUID) -> Set<Int>? {
        return instruments.first(where: { $0.id == instrumentId })?.sequence
    }
}


