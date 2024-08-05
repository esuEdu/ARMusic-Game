//
//  File.swift
//
//
//  Created by Eduardo on 02/08/24.
//

import Foundation
import RealityKit
import ARKit
import Combine
import DataPackage
import AudioPackage

@MainActor
@Observable public class ARViewManager: NSObject {
    public static var shared = ARViewManager()
    public var arView: MainARView?
    public var stateMachine = ARStateMachine()
    
    var modelLoader = ModelLoader()
    
    
    public override init() {
        super.init()
        MetalConfig.initialize()

    
    }
    
   
}



extension ARViewManager: UIGestureRecognizerDelegate {
    // UIGestureRecognizerDelegate method to allow simultaneous gesture recognition
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // UIGestureRecognizerDelegate method to prevent tap when long press is recognized
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UITapGestureRecognizer && otherGestureRecognizer is UILongPressGestureRecognizer {
            return true
        }
        return false
    }
}
