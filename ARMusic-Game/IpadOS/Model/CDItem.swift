//
//  CDItem.swift
//  ARMusic-Game
//
//  Created by Thiago Pereira de Menezes on 12/08/24.
//

import Foundation

struct CDItem: Identifiable {
    let id = UUID()
    let text: String
    let descricao: String
    var image: String?
    var isDefinido: Bool = false
}
