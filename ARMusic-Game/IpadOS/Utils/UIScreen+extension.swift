//
//  UIScreen+extension.swift
//  ImageParallax
//
//  Created by Thiago Pereira de Menezes on 12/08/24.
//

import UIKit

extension UIScreen {
    /// Propriedade calculada para obter a largura da tela.
    static var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }

    /// Propriedade calculada para obter a altura da tela.
    static var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
}
