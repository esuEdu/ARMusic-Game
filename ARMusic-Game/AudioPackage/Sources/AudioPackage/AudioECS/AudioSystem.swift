//
//  File.swift
//  
//
//  Created by Eduardo on 22/07/24.
//

import Foundation
import AVFoundation
import RealityKit


public struct AudioComponent: Component {
    var note: String
}

public class AudioSystem: System {
    
    public required init(scene: Scene) {}
    
    var audioPlayer: AVAudioPlayer?

    public init() {}

    public static var dependencies: [SystemDependency] {
        return []
    }

    public func update(context: SceneUpdateContext) {
        let query = EntityQuery(where: .has(AudioComponent.self))
        let entities = context.scene.performQuery(query)

        for entity in entities {
            if let audio = entity.components[AudioComponent.self] as? AudioComponent {
                playSound(file: audio.note)
            }
        }
    }

    private func playSound(file: String) {
        guard let url = Bundle.main.url(forResource: file, withExtension: nil) else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
}
