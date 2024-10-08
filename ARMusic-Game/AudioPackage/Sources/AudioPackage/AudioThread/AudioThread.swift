//
//  File.swift
//
//
//  Created by Eduardo on 25/07/24.
//
import Foundation
import AVFoundation
import simd

public class AudioThread: Thread {
    
    private var audioEngine: AVAudioEngine = AVAudioEngine()
    private var environmentNode: AVAudioEnvironmentNode = AVAudioEnvironmentNode()
    private var audioPlayerNode: AVAudioPlayerNode = AVAudioPlayerNode()
    private var audioFile: AVAudioFile?
    private var url: URL
    private let position: SIMD3<Float>
    private let audioUtil = AudioUtils.shared
    private let noteDuration: Float
    public var maxVolume: Float = 1.0
    
    public init(at position: SIMD3<Float>, with url: URL, noteDuration: Float) {
        self.url = url
        self.position = position
        self.noteDuration = noteDuration
        super.init()
        setupAudioEngine()
        loadAudioFile()
    }
    
    func denit() {
        cleanup()
    }
    
    private func setupAudioEngine() {
        audioEngine.attach(audioPlayerNode)
        audioEngine.attach(environmentNode)
        
        audioEngine.connect(audioPlayerNode, to: environmentNode, format: nil)
        audioEngine.connect(environmentNode, to: audioEngine.mainMixerNode, format: nil)
        audioEngine.mainMixerNode.position = AVAudio3DPoint(x: position.x, y: position.y, z: position.z)
        
        do {
            try audioEngine.start()
        } catch {
            print("Audio engine failed to start: \(error)")
        }
    }
    
    private func loadAudioFile() {
        do {
            audioFile = try AVAudioFile(forReading: url)
        } catch {
            print("Failed to load audio file: \(error)")
        }
    }
    
    override public func main() {
        playSound()
        while (audioPlayerNode.isPlaying) {
            Thread.sleep(forTimeInterval: 0.1)
        }
        Thread.exit()
    }
    
    public func updateListenerPosition() {
        guard let position = audioUtil.position, let orientation = audioUtil.orientation else { return }
        
        adjustPanBasedOnOrientation()
        adjustVolumeBasedOnDistance(listenerPosition: position)
        environmentNode.listenerPosition = AVAudio3DPoint(x: position.x, y: position.y, z: position.z)
        environmentNode.listenerAngularOrientation = AVAudio3DAngularOrientation(yaw: orientation.y, pitch: orientation.x, roll: orientation.z)
    }
    
    public func playSound() {
        guard let audioFile = audioFile else { return }
        
        audioPlayerNode.scheduleFile(audioFile, at: nil, completionHandler: nil)
        updateListenerPosition()
        audioPlayerNode.position = AVAudio3DPoint(x: position.x, y: position.y, z: position.z)
        audioPlayerNode.renderingAlgorithm = .HRTFHQ
        
        audioPlayerNode.play()
    }
    
    private func adjustVolumeBasedOnDistance(listenerPosition: SIMD3<Float>) {
        let distance = simd_distance(listenerPosition, position)
        let maxDistance: Float = 5.0
        let minVolume: Float = 0.1
        let volume = max(minVolume, 1 - (distance / maxDistance))
        
        audioPlayerNode.volume = min(volume, maxVolume)
    }
    
    private func cleanup() {
        audioEngine.stop()
        audioEngine.detach(audioPlayerNode)
        audioEngine.detach(environmentNode)
    }
    
    private func adjustPanBasedOnOrientation() {
        
        let cameraSpace4 = simd_mul(simd_float4(position.x, position.y, position.z, 1.0), AudioUtils.shared.viewMatrix!)
        let cameraSpace = simd_float3(cameraSpace4.x, cameraSpace4.y, cameraSpace4.z)
        
        let z = simd_float3(-1, 0, 0)
        
        let dirToObj = simd_normalize(cameraSpace)
        let dot = simd_dot(dirToObj, z)
        
        environmentNode.pan = dot
        
    }
}
