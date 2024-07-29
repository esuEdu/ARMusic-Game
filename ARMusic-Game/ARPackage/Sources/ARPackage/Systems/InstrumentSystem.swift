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
        
        ModelLoader.load(name: instrument.modelName) { entity in
            guard let modelEntity = entity else {
                print("Failed to load the instrument model.")
                return
            }
            
            // Criar uma consulta de raycast a partir do centro da ARView
            let raycastQuery = arView.makeRaycastQuery(from: arView.center, allowing: .estimatedPlane, alignment: .horizontal)
            
            if let result = arView.session.raycast(raycastQuery!).first {
                // Criação do AnchorEntity baseado no resultado do raycast
                let anchorEntity = AnchorEntity(raycastResult: result)
                anchorEntity.addChild(modelEntity)
                
                // Adicionar componentes de colisão e instalar gestos
                modelEntity.generateCollisionShapes(recursive: true)
                arView.installGestures([.all], for: modelEntity as! HasCollision)
                
                arView.scene.anchors.append(anchorEntity)
                
                // Atualizar a lista de entidades de instrumentos
                self.instrumentEntities.append(modelEntity)
            } else {
                print("Nenhum plano detectado.")
            }
        }
    }
    
    public func playNoteOnInstrument(_ instrumentEntity: Entity, note: Note) {
        //        let audioComponent = AudioComponent(entity: instrumentEntity, audioFile: note.audioFile)
        //        instrumentEntity.components[AudioComponent.self] = audioComponent
        //        audioComponent.play()
    }
    
}
