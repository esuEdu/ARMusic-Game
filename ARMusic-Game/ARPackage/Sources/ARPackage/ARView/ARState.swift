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

public enum ARState: Equatable {
    

    case normal
    case editing(Entity)
    case dragging(Entity)
    
    
}

@Observable
public class ARStateMachine {
    public var state: ARState = .normal
    
    public func enterEditingMode(with entity: Entity) {
        state = .editing(entity)
        
        WorldSystem.editEntity(entity)
        
    }
    
    public func exitEditingMode() {
        state = .normal
        
        
        WorldSystem.stopEditting()
    }
    
    public func enterDraggingMode(with entity: Entity) {
        state = .dragging(entity)
    }
    
    public func exitDraggingMode() {
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

