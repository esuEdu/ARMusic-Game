//
//  DeleteBuddyButtomView.swift
//  ARMusic-Game (IpadOS)
//
//  Created by Eduardo on 09/08/24.
//

import SwiftUI
import ARPackage

struct DeleteBuddyButtonView: View {
    
    @Environment(ARViewManager.self) private var arViewManager: ARViewManager
    
    var body: some View {
        GeometryReader { geometry in
            ActionButtonView(
                iconName: "xmark",
                action: arViewManager.arView!.removeEntity,  // Action passed here
                backgroundColor: .red,
                iconColor: .white
            )
            .position(x: geometry.size.width * 0.1, y: geometry.size.height * 0.1) // Positioning using multiplication
        }
        .edgesIgnoringSafeArea(.all) // To ignore safe area and position the button at the edge
    }
}


#Preview {
    DeleteBuddyButtonView()
}
