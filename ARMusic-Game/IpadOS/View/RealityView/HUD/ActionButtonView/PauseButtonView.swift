//
//  SwiftUIView.swift
//  ARMusic-Game (IpadOS)
//
//  Created by Erick Ribeiro on 01/08/24.
//

import SwiftUI

struct PauseButtonView: View {
    @Binding var isPaused: Bool
    var body: some View {
        ActionButtonView(
            iconName: "pause",
            action: { isPaused.toggle() },
            backgroundColor: .white,
            iconColor: .black
        )
        .position(x: self.screenWidth * 0.9, y: self.screenHeight * 0.095)
    }
}

#Preview {
    PauseButtonView(isPaused: Binding.constant(true))
}
