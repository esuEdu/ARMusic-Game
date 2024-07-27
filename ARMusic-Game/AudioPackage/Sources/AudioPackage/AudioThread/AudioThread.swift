//
//  File.swift
//
//
//  Created by Eduardo on 25/07/24.
//

import Foundation
import AVFAudio
import simd

public class AudioThread: Thread {
    
    private var audioEngine: AVAudioEngine = AVAudioEngine()
    private var environmentNode: AVAudioEnvironmentNode = AVAudioEnvironmentNode()
    private var audioPlayerNode: AVAudioPlayerNode = AVAudioPlayerNode()
    private var audioFile: AVAudioFile?
    private var url: URL
    private let position: SIMD3<Float>
    private let audioUtil = AudioUtils.shared
    
    var isMuted: Bool = false
    var previousVolume: Float = 1.0
    
    public init(at position: SIMD3<Float> ,with url: URL) {
        self.url = url
        self.position = position
        super.init()
        setupAudioEngine()
    }
    
    private func setupAudioEngine() {
        
        do {
            try audioEngine.start()
        } catch {
            print("Audio engine failed to start: \(error)")
        }
    }
    
    override public func main() {
    }
    
    public func updateListenerPosition() {
        
        guard let possition = audioUtil.possition, let orientation = audioUtil.orientation else { return }
        
        environmentNode.listenerPosition = AVAudio3DPoint(x: possition.x, y: possition.y, z: possition.z)
        environmentNode.listenerAngularOrientation = AVAudio3DAngularOrientation(yaw: orientation.y, pitch: orientation.x, roll: orientation.z)
        
    }
    
    
    public func playSound() {
        do {
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
    
    public func pause() {
        audioPlayerNode.pause()
        
    }
    
    public func mute() {
        isMuted = true
        previousVolume = audioPlayerNode.volume
        audioPlayerNode.volume = 0
    }
    
    public func unmute() {
        isMuted = false
        audioPlayerNode.volume = previousVolume
    }
    
    public func stopPlayback() {
        audioPlayerNode.stop()
    }
}
