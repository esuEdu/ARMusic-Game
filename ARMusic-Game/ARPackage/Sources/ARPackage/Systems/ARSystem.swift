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

public class ARSystem {
    public var arView: ARView?

    public init(arView: ARView) {
        self.arView = arView
    }

    public func setupAR() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        arView?.session.run(configuration)
    }
}
