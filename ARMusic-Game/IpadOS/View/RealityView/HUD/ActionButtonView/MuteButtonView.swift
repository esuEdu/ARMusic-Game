//
//  SwiftUIView.swift
//  ARMusic-Game (IpadOS)
//
//  Created by Erick Ribeiro on 01/08/24.
//

import SwiftUI
import ARPackage

struct MuteButtonView: View {

    @Environment(ARViewManager.self) var arViewManager: ARViewManager
    
    var body: some View {
        
        @Bindable var arViewManager = arViewManager
        
        
        ActionButtonView(
            iconName: arViewManager.muted ? "speaker.slash.fill" : "speaker.2.fill",
            action: {
                arViewManager.muted.toggle()
            },
            backgroundColor: .white,
            iconColor: .black
        )
        .position(x: self.screenWidth * 0.82, y: self.screenHeight * 0.095)
    }
}

#Preview {
    MuteButtonView()
}
