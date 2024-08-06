//
//  Custom3DView.swift
//  ARMusic-Game (IpadOS)
//
//  Created by Thiago Pereira de Menezes on 01/08/24.
//

import SwiftUI
import ARKit
import CoreMotion

struct Custom3DView: UIViewRepresentable {
    
    @Binding var scene: SCNScene?
    var rotation: (x: Double, y: Double)
    
    func makeUIView(context: Context) -> some UIView {
        let view = SCNView()
        view.allowsCameraControl = false
        view.autoenablesDefaultLighting = true
        view.antialiasingMode = .multisampling2X
        view.backgroundColor = .clear
        
        if let scene = scene {
            view.scene = scene
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        guard let scene = scene else { return }
        
        let scnView = uiView as! SCNView
        if scnView.scene == nil {
            scnView.scene = scene
        }
        
        let chairNode = scene.rootNode.childNodes.first
        chairNode?.eulerAngles.x = Float(rotation.x * .pi / 180)
        chairNode?.eulerAngles.y = Float(rotation.y * .pi / 180)
    }
}
 
