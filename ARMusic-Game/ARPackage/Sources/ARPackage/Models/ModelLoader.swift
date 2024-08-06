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

    public static var loadedModels: [String: InstrumentEntity] = [:]
    public static var allLoaded = false
    public static func loadAllModels() {
        
        if (!allLoaded) {
            let instruments = Instruments.allCases
            
            for instrument in instruments {
                load(instrument: instrument)
            }
            
            allLoaded = true
        }
        
        
        
    }
    
    public static func loadModel(for instrument: Instruments, into anchor: AnchorEntity, with arView: ARView) {
        let modelName = instrument.rawValue
        
        let position: SIMD3<Float> = getPosition(arView)
        
        if loadedModels[modelName] == nil {
            load(instrument: instrument)
        }
        
        let entity = loadedModels[modelName]!.clone(recursive: true)
        entity.position = position
        anchor.addChild(entity)
    }
    
    private static func load(instrument: Instruments) {
        
        let modelData = ModelData(instrument: instrument)
        
        guard let url = modelData.getURL() else {
            fatalError("Incorrect instrument URL")
        }
                
        let entity = try! Entity.loadModel(contentsOf: url)
        
        let instrumentEntity = InstrumentEntity.fromModelEntity(entity, instrument: instrument)
    
        loadedModels[instrument.rawValue] = instrumentEntity
    }
    
    private static func getPosition(_ arView: ARView) -> SIMD3<Float> {
        var position: SIMD3<Float> = .zero
        
        let raycast = arView.raycast(from: arView.center, allowing: .estimatedPlane, alignment: .horizontal)

        if let first = raycast.first {
            position = first.worldTransform.position
        }
        
        return position
    }
}

extension simd_float4x4 {
    public var position: simd_float3 {
        
        simd_float3(x: columns.3.x, y: columns.3.y, z: columns.3.z)
        
    }
}
