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
            iconName: "pause.fill",
            action: { isPaused.toggle() },
            backgroundColor: .white,
            iconColor: .black
        )
    }
}

#Preview {
    PauseButtonView(isPaused: Binding.constant(true))
}
