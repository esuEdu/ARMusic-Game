//
//  ContentView.swift
//  ARMusic-Game
//
//  Created by Eduardo on 18/07/24.
//

import SwiftUI
import RealityKit
import AudioPackage


struct ContentView: View {
    @Bindable private var viewModel = ContentViewModel()
    
    var body: some View {
        VStack {
            arViewRepresetable(viewModel: viewModel)
        }.task {
            registerECS()
        }
    }
    
    func registerECS () {
        AudioSystem.registerSystem()
        
        AudioComponent.registerComponent()
    }
}
