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
import DataPackage

@Observable
public class InstrumentSystem {
    public static var shared = InstrumentSystem()
    
    public var arView: ARView?
    public var instrumentEntities: [Entity] = []
    public var selectedEntity: Entity?
    
    public var entityBinding: Binding<Entity?> {
        Binding {
            self.selectedEntity
        } set: { newValue in
            self.selectedEntity = newValue
        }
    }
    
    public init(arView: ARView? = nil) {
        self.arView = arView
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
                arView.installGestures([.all], for: instrumentEntity as! HasCollision)
                
                arView.scene.anchors.append(anchorEntity)
                
                self.instrumentEntities.append(instrumentEntity)
                
                print("Instrument added successfully.")
            } else {
                print("Nenhum plano detectado.")
            }
        }
    }
    
    public func handleTapOnEntity(_ entity: Entity) {
        selectedEntity = entity
    }
    
    public func changeEntity(for entity: Entity, tempos: Set<Int>) {
        // Verifica se a entidade possui filhos e procura pelo AudioComponent
        if var audioComponent = entity.components[AudioComponent.self] as? AudioComponent {
            // Passar nota selecionada:
            // entity.instrument.selectedNote
            print(tempos)
            audioComponent.tempo.setAllValues(to: false)
            audioComponent.tempo.toggleValues(at: tempos)
            
            entity.components.set(audioComponent)
            print("AudioComponent atualizado com sucesso no filho da entidade.")
            return
        }
        
        print("AudioComponent não encontrado em nenhum dos filhos da entidade.")
    }
    
    public func changeEntity(for entity: Entity?, note: Notes) {
        // Verifica se a entidade possui filhos e procura pelo AudioComponent
        if var audioComponent = entity?.components[AudioComponent.self] as? AudioComponent {
            audioComponent.note = note
            // adicionar tocar nota uma vez
            entity?.components.set(audioComponent)
            print("AudioComponent atualizado com sucesso no filho da entidade.")
            return
        }
        
        print("AudioComponent não encontrado em nenhum dos filhos da entidade.")
    }
}
