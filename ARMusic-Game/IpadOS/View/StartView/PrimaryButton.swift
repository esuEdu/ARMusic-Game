//
//  File.swift
//  ARMusic-Game
//
//  Created by Erick Ribeiro on 11/08/24.
//

import SwiftUI

struct PrimaryButton: View {
    var action: () -> Void
    var title: String
    @State private var isPressed = false

    var body: some View {
        Button(action: action) {
            ZStack{
                Image(.primaryButton)
                    .resizable()
                    .scaledToFit()
                
                Text(title)
                    .customFont(.metarin, textStyle: .title)
                    .bold()
                    .foregroundStyle(.primaryPurple)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 15)
                    .shadow(
                        color: Color.black.opacity(0.5),
                        radius: 0.5,
                        x: 1.2,
                        y: 2.97
                    )
            }
        }
        .frame(maxWidth: 573, minHeight: 50)
        .scaleEffect(isPressed ? 0.85 : 1.0)
        .animation(.easeInOut(duration: 0.4), value: isPressed)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    withAnimation {
                        isPressed = false
                    }
                }
        )
    }
}

