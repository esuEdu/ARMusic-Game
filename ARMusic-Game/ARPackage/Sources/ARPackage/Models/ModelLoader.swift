//
//  InstrumentModel.swift
//
//
//  Created by Erick Ribeiro on 28/07/24.
//

import RealityKit
import Combine
import Foundation
import AudioPackage
import DataPackage

public class ModelLoader {
    var cancellable: AnyCancellable?
    var loadedModels: [String: Entity] = [:]
    
    func loadModel(for instrumentEntity: InstrumentEntity, into anchor: AnchorEntity, with arView: ARView) {
        let modelName = instrumentEntity.instrument.rawValue
        
        instrumentEntity.transform.scale = simd_float3(0.05, 0.05, 0.05)
        
        let position: SIMD3<Float> = getPosition(arView)
        
        if let existingModel = loadedModels[modelName] {
            
            // Clone the existing model
            let clonedEntity = existingModel.clone(recursive: true)
            instrumentEntity.addChild(clonedEntity)
            
            instrumentEntity.addOutlineComponent()
            instrumentEntity.addCollisionComponent()
            positionEntity(instrumentEntity, in: anchor, at: position)
            
            print("Cloned model for \(instrumentEntity.instrument) loaded successfully")
            
        } else {
            // Load a new model
            cancellable = Entity.loadModelAsync(contentsOf: getURL(instrument: instrumentEntity.instrument))
                .sink(receiveCompletion: { loadCompletion in
                    switch loadCompletion {
                        case .failure(let error):
                            print("Error loading model: \(error.localizedDescription)")
                        case .finished:
                            break
                    }
                }, receiveValue: { entity in
                    self.loadedModels[modelName] = entity
                    instrumentEntity.addChild(entity)
                    
                    instrumentEntity.addCollisionComponent()
                    self.positionEntity(instrumentEntity, in: anchor, at: position)
                    print("Model for \(instrumentEntity.instrument) loaded successfully")
                })
        }
    }
    
    private func positionEntity(_ entity: Entity, in anchor: AnchorEntity, at position: SIMD3<Float>) {
        entity.position = position
        anchor.addChild(entity)
    }
    
    private func getPosition(_ arView: ARView) -> SIMD3<Float> {
        var position: SIMD3<Float> = .zero
        
        if let query = arView.makeRaycastQuery(from: arView.center, allowing: .estimatedPlane, alignment: .horizontal) {
            let results = arView.session.raycast(query)
            
            if let firstResult = results.first {
                position = SIMD3<Float> (firstResult.worldTransform.columns.3.x,
                                         firstResult.worldTransform.columns.3.y,
                                         firstResult.worldTransform.columns.3.z)
            }
        }
        
        return position
    }
    
    private func getURL(instrument: Instruments) -> URL {
        let audioData = ModelData(instrument: instrument)
        
        guard let url = audioData.getURL() else {
            fatalError("Audio file not found")
        }
        return url
    }
}
