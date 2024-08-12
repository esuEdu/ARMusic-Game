//
//  BackButtonView.swift
//  ARMusic-Game (IpadOS)
//
//  Created by Victor Soares on 05/08/24.
//

import SwiftUI
import ARPackage

struct BackButtonView: View {
    @Environment(ARViewManager.self) var arViewManager: ARViewManager
    
    var body: some View {
        ActionButtonView(
            iconName: "back",
            action: { arViewManager.stateMachine.exitEditingMode() },
            backgroundColor: .white,
            iconColor: .black
        )
        .position(x: self.screenWidth * 0.1, y: self.screenHeight * 0.1) 
    }
}

#Preview {
    BackButtonView()
}
