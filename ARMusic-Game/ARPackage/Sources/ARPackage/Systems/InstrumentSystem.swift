//
//  InstrumentSystem.swift
//
//
//  Created by Erick Ribeiro on 28/07/24.
//

import RealityKit
import Combine
import SwiftUI
import AudioPackage

@Observable
public class InstrumentSystem {
    public static var shared = InstrumentSystem()
    
    public var arView: ARView?
    private var sharedAnchor: AnchorEntity?
    
    public var instrumentEntities: [InstrumentEntity] = []
    public var selectedEntity: InstrumentEntity?
    
    public var entityBinding: Binding<InstrumentEntity?> {
        Binding {
            self.selectedEntity
        } set: { newValue in
            self.selectedEntity = newValue
        }
    }
    
    public init(arView: ARView? = nil) {
        self.arView = arView
        // Initialize shared anchor
        sharedAnchor = AnchorEntity()
        arView?.scene.anchors.append(sharedAnchor!)
    }
    
    public func addInstrument(_ instrument: Instrument) {
        guard let arView = arView else { return }
        
        ModelLoader.load(instrument: instrument, instrumentSystem: self) { [weak self] instrumentEntity in
            guard let self = self else { return }
            guard let instrumentEntity = instrumentEntity else {
                print("Failed to load the instrument model.")
                return
            }
                        
            let raycastQuery = arView.makeRaycastQuery(from: arView.center, allowing: .estimatedPlane, alignment: .horizontal)
            
            if let result = arView.session.raycast(raycastQuery!).first {
                let anchorEntity = AnchorEntity(raycastResult: result)
                anchorEntity.addChild(instrumentEntity)
                
                instrumentEntity.generateCollisionShapes(recursive: true)
                arView.installGestures([.all], for: instrumentEntity as HasCollision)
                
                arView.scene.anchors.append(anchorEntity)
                
                self.instrumentEntities.append(instrumentEntity)
                print("Instrument added successfully.")
            } else {
                print("Nenhum plano detectado.")
            }
        }
    }
    
    public func handleTapOnEntity(_ entity: InstrumentEntity) {
        selectedEntity = entity
    }
    
    public func setSequence(for entity: InstrumentEntity) {
        selectedEntity = entity
        print(entity.components)
        
        // Verifica se a entidade possui filhos e procura pelo AudioComponent
        for child in entity.children {
            if var audioComponent = child.components[AudioComponent.self] as? AudioComponent {
                // Passar nota selecionada:
               // entity.instrument.selectedNote
                audioComponent.tempo.setAllValues(to: false)
                audioComponent.tempo.toggleValues(at: entity.instrument.sequence)
                
                child.components.set(audioComponent)
                
                print("AudioComponent atualizado com sucesso no filho da entidade.")
                return
            }
        }
        
        print("AudioComponent não encontrado em nenhum dos filhos da entidade.")
    }
}
