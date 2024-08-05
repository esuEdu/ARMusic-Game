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
    public static var entityBeingEditted: Entity? {
        didSet {
            if entityBeingEditted != nil {
                AudioSystem.entityBeingEdited = entityBeingEditted
            } else {
                AudioSystem.entityBeingEdited = nil
            }
        }
    }
    
    public required init(scene: Scene) {}
    
//    public static var worldSettings: ARSettings!
    
    public static func editEntity(_ entity: Entity?) {
        entityBeingEditted = entity
    }
    
    public static func stopEditting() {
        entityBeingEditted = nil
    }
}
