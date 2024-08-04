//
//  MotionManager.swift
//  ARMusic-Game (IpadOS)
//
//  Created by Thiago Pereira de Menezes on 30/07/24.
//

import CoreMotion

class MotionManager: ObservableObject {
    private let motionManager = CMMotionManager()
    
    @Published var pitch: Double = 0.0 // inclinação
    @Published var roll: Double = 0.0 // rolagem
    
    func startMonitoringMotionUpdates() {
        
        guard self.motionManager.isDeviceMotionAvailable else {
            print("Device motion not available")
            return
        }
        
        self.motionManager.deviceMotionUpdateInterval = 0.01
        
        self.motionManager.startDeviceMotionUpdates(to: .main) { motion, erro in
            
            guard let motion = motion else { return }
            
            self.pitch = motion.attitude.pitch
            self.roll = motion.attitude.roll
        }
    }
    
    func stopCollectingData() {
        self.motionManager.stopDeviceMotionUpdates()
        self.motionManager.stopGyroUpdates()
    }
}
