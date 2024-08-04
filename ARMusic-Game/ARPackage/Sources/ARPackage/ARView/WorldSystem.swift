//
//  WorldSystem.swift
//
//
//  Created by Eduardo on 25/07/24.
//

import RealityKit
import ARKit
import AudioPackage

public class WorldSystem: System {
    public static var entityBeingEditted: ModelEntity? {
        didSet {
            if entityBeingEditted != nil {
                AudioSystem.entityBeingEditted = entityBeingEditted
            } else {
                AudioSystem.entityBeingEditted = nil
            }
        }
    }
    
    public required init(scene: Scene) {}
    
//    public static var worldSettings: ARSettings!
    
    public static func editEntity(_ entity: ModelEntity) {
        entityBeingEditted = entity
    }
}
