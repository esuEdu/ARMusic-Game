//
//  HalfCircle.swift
//  ARMusic-Game (IpadOS)
//
//  Created by Thiago Pereira de Menezes on 08/08/24.
//

import SwiftUI

// Cículo cortado pela metade
struct HalfCircle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: CGPoint(x: 0, y: rect.midY),
                    radius: rect.midY,
                    startAngle: .degrees(-90),
                    endAngle: .degrees(90),
                    clockwise: false)
        path.addLine(to: CGPoint(x: 0, y: rect.maxY))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.closeSubpath()
        return path
    }
}

#Preview {
    HalfCircle()
}
