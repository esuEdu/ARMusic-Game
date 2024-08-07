//
//  SwiftUIView.swift
//  ARMusic-Game (IpadOS)
//
//  Created by Erick Ribeiro on 06/08/24.
//

import SwiftUI

struct ButtonPauseView: View {
    var title: String
    var action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            action()
        }) {
            Text(title)
                .padding()
                .containerRelativeFrame(.horizontal){ width, _ in width * 0.3}
                .background(Color.gray.opacity(0.2))
                .foregroundStyle(.black)
                .font(.headline)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 2)
                )
                .scaleEffect(isPressed ? 0.85 : 1.0)
                .animation(.easeInOut(duration: 0.4), value: isPressed)
        }
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


