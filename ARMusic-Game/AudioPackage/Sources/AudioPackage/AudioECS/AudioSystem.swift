//
//  File.swift
//  
//
//  Created by Eduardo on 22/07/24.
//

import Foundation
import DataPackage
import RealityKit


public struct AudioComponent: Component {
    var note: Notes
    var intrument: Instruments
    var tom: Float
    var tempo: Float
    
    public init(note: Notes, instrument: Instruments, tom: Float, tempo: Float) {
        self.note = note
        self.intrument = instrument
        self.tom = tom
        self.tempo = tempo
    }
}

public class AudioSystem: System {
    
    public var audioThreads: [Entity: AudioThread] = [:]
    
    public required init(scene: Scene) {}

    public static var dependencies: [SystemDependency] {
        return []
    }

    public func update(context: SceneUpdateContext) {
        let query = EntityQuery(where: .has(AudioComponent.self))
        let entities = context.scene.performQuery(query)

        for entity in entities {
            if audioThreads[entity] == nil {
                playThread(entity: entity)
            }
        }
    }
    
    
    public func playThread(entity: Entity) {
        
        if let audio = entity.components[AudioComponent.self] as? AudioComponent {
            
            // get the audio url file
            let url = getURL(instrument: audio.intrument, note: audio.note)
            
            //create an audio thread
            let audioThread = AudioThread(at: entity.position, with: url)
            
            //save the entity audio thread for more control
            audioThreads[entity] = audioThread
            
            //start the thread
            audioThread.start()
            
        }
    }

    public func pause(entity: Entity) {
        audioThreads[entity]?.pause()
    }

    public func mute(entity: Entity) {
        audioThreads[entity]?.mute()
    }

    public func unmute(entity: Entity) {
        audioThreads[entity]?.unmute()
    }

    public func stop(entity: Entity) {
        audioThreads[entity]?.stopPlayback()
        audioThreads[entity] = nil
    }
    
    private func getURL(instrument: Instruments, note: Notes) -> URL {
        let audioData = AudioData(instrument: instrument, note: note)
        
        guard let url = audioData.getURL() else {
            fatalError("Audio file not found")
        }
        return url
    }
}
