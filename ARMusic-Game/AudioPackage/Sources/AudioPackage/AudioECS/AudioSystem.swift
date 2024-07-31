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
    
    var noteDuration = {
        Float(7500/AudioUtils.shared.BPM)
    }()
    
    var currentNote: Int = 0
    var currentBeat: Int = 0
    
    var maxBeat: Int = 0
    
    var soundPlayedForCurrentNote: Bool = false

    var timer: Timer?
    public static var entityBeingEditted: ModelEntity?
    
    
    public required init(scene: Scene) {
        startTimer()
    }
    
    public static var dependencies: [SystemDependency] {
        return []
    }
    
    public func update(context: SceneUpdateContext) {
        if soundPlayedForCurrentNote {
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
        
        
        soundPlayedForCurrentNote = true
    }
    
    private func handleEntitySound(entity: Entity) {
        
        if let audio = entity.components[AudioComponent.self] as? AudioComponent {
            getMaxBeat(beat: audio.endBeat)
            if currentBeat >= audio.startBeat && currentBeat <= audio.endBeat {
                let entityTempo = audio.tempo.getArray()
                if entityTempo[currentNote] {
                    print(entityTempo[currentNote])
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
            let audioThread = AudioThread(at: entity.position, with: url, noteDuration: noteDuration)
            
            //start the thread
            audioThread.start()
        }
    }
    
    public func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(noteDuration / 1000), repeats: true) { _ in
            self.updateTime()
        }
    }
    
    public func pauseTimer() {
        timer?.invalidate()
    }
    
    public func resetTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func updateTime() {
        currentNote += 1
        if currentNote >= 8 {
            currentNote = 0
            currentBeat += 1
            
            if currentBeat >= maxBeat {
                currentBeat = 0
            }
        }
        soundPlayedForCurrentNote = false
        print("Current Beat: \(currentBeat), Current Note: \(currentNote)")
    }
    
    func getMaxBeat(beat: Int) {
        if beat > maxBeat {
            maxBeat = beat
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
