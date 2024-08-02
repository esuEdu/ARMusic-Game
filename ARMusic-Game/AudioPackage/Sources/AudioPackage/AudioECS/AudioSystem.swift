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
    public var note: Notes
    var intrument: Instruments
    var tom: Float
    public var tempo = FixedSizeBoolArray(size: 8)
    
    var startBeat: Int
    var endBeat: Int
    
    
    public init(note: Notes, instrument: Instruments, tom: Float, startBeat: Int = 0, endBeat: Int = 1) {
        self.note = note
        self.intrument = instrument
        self.tom = tom
        self.startBeat = startBeat
        self.endBeat = endBeat
    }
}

public class AudioSystem: System {
    
    
    public required init(scene: Scene) {}
    
    public static var entityBeingEditted: ModelEntity?
    
    public static var dependencies: [SystemDependency] {
        return []
    }
    
    public func update(context: SceneUpdateContext) {
        if AudioTimerManager.shared.soundPlayedForCurrentNote {
            return
        }
        
        let query = EntityQuery(where: .has(AudioComponent.self))
        let entities = context.scene.performQuery(query)
        
        if let entityBeingEditted = AudioSystem.entityBeingEditted {
            handleEntitySound(entity: entityBeingEditted)
        } else {
            for entity in entities {
                handleEntitySound(entity: entity)
            }
        }
        
        
        AudioTimerManager.shared.soundPlayedForCurrentNote = true
    }
    
    private func handleEntitySound(entity: Entity) {
        
        if let audio = entity.components[AudioComponent.self] as? AudioComponent {
            getMaxBeat(beat: audio.endBeat)
            if AudioTimerManager.shared.currentBeat >= audio.startBeat && AudioTimerManager.shared.currentBeat <= audio.endBeat {
                let entityTempo = audio.tempo.getArray()
                if entityTempo[AudioTimerManager.shared.currentNote] {
                    print(entityTempo[AudioTimerManager.shared.currentNote])
                    playSound(entity: entity)
                }
            }
        }
        
    }
    
    public func playSound(entity: Entity) {
        
        if let audio = entity.components[AudioComponent.self] as? AudioComponent {
            
            // get the audio url file
            let url = getURL(instrument: audio.intrument, note: audio.note)
            
            //create an audio thread
            let audioThread = AudioThread(at: entity.position, with: url, noteDuration: AudioTimerManager.shared.noteDuration)
            
            //start the thread
            audioThread.start()
        }
    }
    
    func getMaxBeat(beat: Int) {
        if beat > AudioTimerManager.shared.maxBeat {
            AudioTimerManager.shared.maxBeat = beat
        }
    }
    
    private func getURL(instrument: Instruments, note: Notes) -> URL {
        let audioData = AudioData(instrument: instrument, note: note)
        
        guard let url = audioData.getURL() else {
            fatalError("Audio file not found")
        }
        return url
    }
}
