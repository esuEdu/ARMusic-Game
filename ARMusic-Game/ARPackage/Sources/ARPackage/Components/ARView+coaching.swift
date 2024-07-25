//
//  File.swift
//  
//
//  Created by Thiago Pereira de Menezes on 22/07/24.
//

import Foundation
import ARKit
import RealityKit

extension ARView: ARCoachingOverlayViewDelegate {
    func addCoaching() {
        let coachingOverlay = ARCoachingOverlayView()

        // Goal is a field that indicates your app's tracking requirements.
        coachingOverlay.goal = .horizontalPlane
             
        // The session this view uses to provide coaching.
        coachingOverlay.session = self.session
             
        // How a view should resize itself when its superview's bounds change.
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        self.addSubview(coachingOverlay)
    }
}
