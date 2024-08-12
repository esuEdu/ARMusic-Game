//
//  CustomFont.swift
//  ARMusic-Game
//
//  Created by Erick Ribeiro on 11/08/24.
//

import SwiftUI

enum CustomFont: String {
    case metarin = "Metarin Free"
    case goodBakwan = "Good Bakwan"
}

struct CustomFontModifier: ViewModifier {
    var textStyle: Font.TextStyle
    var fontName: CustomFont
    var size: CGFloat?

    func body(content: Content) -> some View {
        content
            .font(.custom(
                fontName.rawValue,
                size: size ?? UIFont.preferredFont(forTextStyle: UIFont.TextStyle(textStyle)).pointSize,
                relativeTo: textStyle
            ))
    }
}

extension UIFont.TextStyle {
    init(_ swiftUITextStyle: Font.TextStyle) {
        switch swiftUITextStyle {
        case .largeTitle: self = .largeTitle
        case .title: self = .title1
        case .title2: self = .title2
        case .title3: self = .title3
        case .headline: self = .headline
        case .subheadline: self = .subheadline
        case .body: self = .body
        case .callout: self = .callout
        case .footnote: self = .footnote
        case .caption: self = .caption1
        case .caption2: self = .caption2
        default: self = .body
        }
    }
}

extension View {
    func customFont(_ font: CustomFont, textStyle: Font.TextStyle, size: CGFloat? = nil) -> some View {
        self.modifier(CustomFontModifier(textStyle: textStyle, fontName: font, size: size))
    }
}

