//
//  InstrumentsInfo.swift
//  ARMusic-Game (IpadOS)
//
//  Created by Erick Ribeiro on 05/08/24.
//

import Foundation
import DataPackage
import SceneKit

struct InstrumentInfo {
    let name: String
    let imageName: String
    let modelName:String?
    let description: String
    
    static func get(for instrument: Instruments) -> InstrumentInfo {
        switch instrument {
        case .piano:
            return InstrumentInfo(
                name: "Piano Men",
                imageName: "background", modelName: "guitarra.usdz",
                description: "Boa pedida para quem gosta dos clássicos"
            )
            case .guitar:
                return InstrumentInfo(
                    name: "Guitar Men",
                    imageName: "background", modelName: "guitarra.usdz",
                    description: "Boa pedida para quem gosta dos clássicos"
                )
        }
    }
}
