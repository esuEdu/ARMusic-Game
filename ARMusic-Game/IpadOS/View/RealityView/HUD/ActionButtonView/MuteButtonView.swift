//
//  SwiftUIView.swift
//  ARMusic-Game (IpadOS)
//
//  Created by Erick Ribeiro on 01/08/24.
//

import SwiftUI

struct MuteButtonView: View {
    @Binding var isMuted: Bool
    var body: some View {
        ActionButtonView(
            iconName: isMuted ? "speaker.slash.fill" : "speaker.2.fill",
            action: {
                isMuted.toggle()
            },
            backgroundColor: .white,
            iconColor: .black
        )
        .position(x: self.screenWidth * 0.82, y: self.screenHeight * 0.095)
    }
}

#Preview {
    MuteButtonView(isMuted: Binding.constant(true))
}
