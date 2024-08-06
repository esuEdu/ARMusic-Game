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
    public var paused: Bool = false {
        didSet {
            paused ? pause() : unpause()
        }
    }
    
    public var arView: MainARView?
    public var stateMachine = ARStateMachine()
    var modelLoader = ModelLoader()
    
    public override init() {
        super.init()
        MetalConfig.initialize()
        ModelLoader.loadAllModels()
    }

    private func unpause() {
        AudioTimerManager.shared.start()
        arView?.resume()
    }
    
    private func pause() {
        AudioTimerManager.shared.pause()
        arView?.pause()
    }
}

extension ARViewManager: ARSessionDelegate {
    public func session(_ session: ARSession, didUpdate frame: ARFrame) {
        let cameraTransform = frame.camera.transform
        let cameraPosition = SIMD3<Float>(cameraTransform.columns.3.x, cameraTransform.columns.3.y, cameraTransform.columns.3.z)
        let cameraOrientation = frame.camera.eulerAngles
        AudioUtils.shared.position = cameraPosition
        AudioUtils.shared.orientation = cameraOrientation
        AudioUtils.shared.viewMatrix = session.currentFrame?.camera.viewMatrix(for: .landscapeLeft)
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
