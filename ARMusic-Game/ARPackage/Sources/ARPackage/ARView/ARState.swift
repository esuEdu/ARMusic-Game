//
//  File.swift
//
//
//  Created by Eduardo on 03/08/24.
//

import Foundation
import SwiftUI
import RealityKit
import ARKit

public enum ARState {
    case normal
    case editing(Entity)
    case dragging(Entity)
}

@Observable public class ARStateMachine {
    public var state: ARState = .normal
    
    func enterEditingMode(with entity: Entity) {
        state = .editing(entity)
        
        #warning("Change this")
        WorldSystem.editEntity(entity)
        
    }
    
    func exitEditingMode() {
        state = .normal
        
        #warning("Change this")
        WorldSystem.editEntity(nil)
    }
    
    func enterDraggingMode(with entity: Entity) {
        state = .dragging(entity)
    }
    
    func exitDraggingMode() {
        state = .normal
    }
    
    public func getEntity() -> Entity? {
        switch state {
            case .editing(let entity), .dragging(let entity):
                return entity
            default:
                return nil
        }
    }
    
    public var currentEntity: Entity? {
        return getEntity()
    }
}

