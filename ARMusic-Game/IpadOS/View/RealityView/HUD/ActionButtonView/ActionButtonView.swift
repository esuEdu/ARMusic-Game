//
//  ActionButtonView.swift
//  ARMusic-Game (IpadOS)
//
//  Created by Erick Ribeiro on 01/08/24.
//

import SwiftUI

struct ActionButtonView: View {
    let iconName: String
    let action: () -> Void
    let backgroundColor: Color
    let iconColor: Color
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Image(.actionButton)
                    .resizable()
                    .scaledToFit()
                    .shadow(
                        color: Color.black.opacity(0.56),
                        radius: 18.19,
                        x: 3.94,
                        y: 4.38
                    )
                
                Image(.purpleSphere)
                    .resizable()
                    .scaledToFit()
                    .containerRelativeFrame(.vertical) { width, _ in
                        width / 12
                    }
                    .shadow(color: .black.opacity(0.3), radius: 4, x: 2, y: 5)
                
                Image(iconName)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(iconColor)
                    .containerRelativeFrame(.vertical){ width, _ in width/20 }
                
            }
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.spring(), value: isPressed)
            .frame(width: self.screenWidth * 0.085)
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



