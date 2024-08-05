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

    var body: some View {
        ZStack(alignment: .center) {
            Circle()
                .fill(backgroundColor)
                .containerRelativeFrame(.vertical){ width, _ in width * 0.12}
            
            Image(systemName: iconName)
                .foregroundColor(iconColor)
                .font(.largeTitle)
                .contentTransition(.symbolEffect(.replace))
        }
        .padding()
        .onTapGesture {
            
            action()
        }
    }
}

