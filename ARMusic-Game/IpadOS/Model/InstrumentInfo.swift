//
//  InstrumentsInfo.swift
//  ARMusic-Game (IpadOS)
//
//  Created by Erick Ribeiro on 05/08/24.
//

import Foundation
import DataPackage

struct InstrumentInfo {
    let name: String
    let imageName: String
    let description: String
    
    static func get(for instrument: Instruments) -> InstrumentInfo {
        switch instrument {
        case .piano:
            return InstrumentInfo(
                name: "Piano Men",
                imageName: "background",
                description: "Boa pedida para quem gosta dos clássicos"
            )
        }
    }
}
