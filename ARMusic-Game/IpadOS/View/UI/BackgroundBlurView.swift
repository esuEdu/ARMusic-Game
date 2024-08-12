//
//  BackgroundBlurView.swift
//  ARMusic-Game
//
//  Created by Erick Ribeiro on 11/08/24.
//

import SwiftUI

struct BackgroundBlurModifier: ViewModifier {
    var cornerRadius: CGFloat
    var blurRadius: CGFloat
    var opacity: Double
    
    func body(content: Content) -> some View {
        content
            .background(
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: .gradiente1, location: 0.0),
                        .init(color: .gradiente2, location: 0.5),
                        .init(color: .gradiente3, location: 1.0)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .opacity(opacity)
                .mask(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .blur(radius: blurRadius)
                )
            )
    }
}

extension View {
    func backgroundBlur(cornerRadius: CGFloat = 15, blurRadius: CGFloat = 20, opacity: Double = 0.9) -> some View {
        self.modifier(BackgroundBlurModifier(cornerRadius: cornerRadius, blurRadius: blurRadius, opacity: opacity))
    }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff
        )
    }
}
