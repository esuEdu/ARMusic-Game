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
    var instrument: Instruments
    public var tom: Float
    public var tempo = FixedSizeBoolArray(size: 8)
    public var startBeat: Int
    public var endBeat: Int
    
    public init(note: Notes = .d, instrument: Instruments, tom: Float = 0.0, startBeat: Int = 0, endBeat: Int = 1) {
        self.note = note
        self.instrument = instrument
        self.tom = tom
        self.startBeat = startBeat
        self.endBeat = endBeat
    }
}

public class AudioSystem: System {
    
    // MARK: - Properties
    public static var entityBeingEdited: Entity?
    
    // MARK: - Initialization
    public required init(scene: Scene) {}
    
    // MARK: - Public Methods
    public func update(context: SceneUpdateContext) {
        // Check if sound has already been played for the current note to avoid duplication
        if AudioTimerManager.shared.soundPlayedForCurrentNote {
            return
        }
        
        // Query for entities with AudioComponent
        let query = EntityQuery(where: .has(AudioComponent.self))
        let entities = context.scene.performQuery(query)
        
        // If there is an entity being edited, handle its sound, otherwise handle all entities' sounds
        if let entityBeingEdited = AudioSystem.entityBeingEdited {
            handleEntitySound(entity: entityBeingEdited)
        } else {
            for entity in entities {
                handleEntitySound(entity: entity)
            }
        }
        
        // Mark sound as played for the current note
        AudioTimerManager.shared.soundPlayedForCurrentNote = true
    }
    
    // MARK: - Private Methods
    private func handleEntitySound(entity: Entity) {
        // Retrieve the AudioComponent of the entity
        if let audio = entity.components[AudioComponent.self] as? AudioComponent {
            // Update the maximum beat if necessary
            getMaxBeat(beat: audio.endBeat)
            
            // Check if the current beat is within the audio's play range
            if AudioTimerManager.shared.currentBeat >= audio.startBeat &&
               AudioTimerManager.shared.currentBeat <= audio.endBeat {
                // Get the tempo array for the entity
                let entityTempo = audio.tempo.getArray()
                
                // If the current note should be played, play the sound
                if entityTempo[AudioTimerManager.shared.currentNote] {
                    print(entityTempo[AudioTimerManager.shared.currentNote])
                    playSound(entity: entity)
                }
            }
        }
    }
    
    private func playSound(entity: Entity) {
        // Retrieve the AudioComponent of the entity
        if let audio = entity.components[AudioComponent.self] as? AudioComponent {
            // Get the URL for the audio file
            let url = getURL(instrument: audio.instrument, note: audio.note)
            
            // Create an audio thread with the URL and entity position
            let audioThread = AudioThread(at: entity.position, with: url, noteDuration: AudioTimerManager.shared.noteDuration)
            audioThread.maxVolume = AudioTimerManager.shared.muted ? 0.0 : 1.0
            
            
            // Start the audio thread
            audioThread.start()
        }
    }
    
    private func getMaxBeat(beat: Int) {
        // Update the maximum beat if the given beat is greater than the current maximum
        if beat > AudioTimerManager.shared.maxBeat {
            AudioTimerManager.shared.maxBeat = beat
        }
    }
    
    private func getURL(instrument: Instruments, note: Notes) -> URL {
        // Create an AudioData object to get the URL for the audio file
        let audioData = AudioData(instrument: instrument, note: note)
        
        // Retrieve the URL and handle the case where the URL is not found
        guard let url = audioData.getURL() else {
            fatalError("Audio file not found")
        }
        return url
    }
}

