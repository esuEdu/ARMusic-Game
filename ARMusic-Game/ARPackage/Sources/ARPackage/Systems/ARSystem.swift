//
//  File.swift
//  
//
//  Created by Eduardo on 22/07/24.
//

import Foundation
import RealityKit
import SwiftUI
import ARKit

public class ARSettings{
    public var arView: ARView?
    
    public var session: ARSession? {
        arView?.session
    }

    public init(arView: ARView) {
        self.arView = arView
    }

    public func setupAR() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        configuration.environmentTexturing = .automatic
        
        arView?.session.run(configuration)
        setupGestures()
        arView?.addCoaching() 
    }
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        
        arView?.addGestureRecognizer(tapGesture)
    }
    
    @objc private func onTap(_ gesture: UITapGestureRecognizer) {
        
        let location = gesture.location(in: arView)
        
        let hitTest = arView?.hitTest(location)
        
        print(hitTest, location)
        
        let withInputComponent = hitTest?.filter({ hit in
            
            let entity = hit.entity
            
            let hasComponent = entity.components.has(InputComponent.self)
            
            return hasComponent
            
        })
        
        if let hits = withInputComponent {
            
            for hit in hits {
                let entity = hit.entity
                
                let inputComponent = entity.components[InputComponent.self] as! InputComponent
                inputComponent.run(gesture: gesture)
            }
            
        }
        
    }
}
