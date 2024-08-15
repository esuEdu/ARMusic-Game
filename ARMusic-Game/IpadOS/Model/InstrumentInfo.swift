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
                name: "orcano",
                imageName: "baleia", modelName: "piano.usdz",
                description: "Boa pedida para quem gosta dos clássicos"
            )
            case .guitar:
                return InstrumentInfo(
                    name: "orcano",
                    imageName: "cogumelo", modelName: "guitar.usdz",
                    description: "Boa pedida para quem gosta dos clássicos"
                )
        }
    }
}
