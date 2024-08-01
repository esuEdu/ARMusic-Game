//
//  ScaledFont.swift
//  JurosCompostos
//
//  Created by Thiago Pereira de Menezes on 30/07/24.
//

import SwiftUI

//Extenção que permite o dynamic type usando valores fixos de font ex: .font(.custom(size: 20))
extension View {
    
    ///Modificador que permite dynamic type usando valores fixos de font ex: .font(.custom(size: 20))
    /// - Parameters:
    ///   - name: O nome da fonte a ser usada. O padrão é o nome da família da fonte do sistema.
    ///   - size: O tamanho da fonte.
    ///   - weight: O peso da fonte. O padrão é `.regular`.
    @ViewBuilder func scaledFont(name: String = UIFont.systemFont(ofSize: 0).familyName, size: CGFloat, weight: Font.Weight = .regular) -> some View {
        
        if #available(iOS 16.0, *) {
            self
                .font(.custom(name, size: size, relativeTo: .body))
                .fontWeight(weight)
        } else {
            self
                .font(
                    .custom(name, size: size, relativeTo: .body)
                    .weight(weight)
                )
        }
    }
}
