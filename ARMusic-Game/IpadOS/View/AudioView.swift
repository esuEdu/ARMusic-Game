//
//  AudioView.swift
//  ARMusic-Game (IpadOS)
//
//  Created by Eduardo on 26/07/24.
//

import Foundation
import RealityKit
import AudioPackage
import SwiftUI

struct AudioView: View {
    @Bindable private var viewModel = AuidoViewModel()
    
    var body: some View {
        VStack {
            arViewRepresetable(viewModel: viewModel)
        }.task {
            register()
        }
    }
    func register() {
        AudioComponent.registerComponent()
        AudioSystem.registerSystem()
    }
}
