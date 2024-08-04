//
//  AudioSystemTests.swift
//  
//
//  Created by Eduardo on 24/07/24.
//

import XCTest
import RealityKit
import AVFoundation
import ARKit

@testable import AudioPackage
@testable import DataPackage


class AudioSystemTests: XCTestCase {
    
    var audioSystem: AudioSystem!
    var arView: ARView!
    
    override func setUp() {
        super.setUp()
        arView = ARView()
        audioSystem = AudioSystem(scene: arView.scene)
    }
    
    override func tearDown() {
        audioSystem = nil
        arView = nil
        super.tearDown()
    }
    
    func testAudioComponentCreation() {
        let entity = Entity()
        let audioComponent = AudioComponent(note: .c, instrument: .piano, tom: 1.0, tempo: 120.0)
        entity.components.set(audioComponent)
        
        XCTAssertNotNil(entity.components[AudioComponent.self])
    }
    
    func testAudioThreadCreation() {
        let entity = Entity()
        let audioComponent = AudioComponent(note: .c, instrument: .piano, tom: 1.0, tempo: 120.0)
        entity.components.set(audioComponent)
        arView.scene.addAnchor(AnchorEntity())
        
        audioSystem.playSound(entity: entity)
        
        XCTAssertNotNil(audioSystem.audioThreads[entity])
    }
    
    func testAudioThreadPlayback() {
        let audioData = AudioData(instrument: .piano, note: .c)
        guard let url = audioData.getURL() else {
            XCTFail("Audio URL should not be nil")
            return
        }
        
        let audioThread = AudioThread(url: url)
        audioThread.start()
        
        // Allow some time for the thread to start
        Thread.sleep(forTimeInterval: 1.0)
        
        XCTAssertNotNil(audioThread, "AudioThread should not be nil")
        XCTAssertTrue(audioThread.isExecuting, "AudioThread should be executing")
        
        audioThread.cancel()
    }
    
    func testAudioBuffer() {
        let file: AVAudioFile
        
        let audioData = AudioData(instrument: .piano, note: .c)
        
        guard let url = audioData.getURL() else {
            XCTFail("Audio URL should not be nil")
            return
        }
        
        do {
            file = try AVAudioFile(forReading: url)
        } catch {
            XCTFail("Audio file should not be nil")
            return
        }
        
        let format = file.processingFormat
        let frameCount = UInt32(file.length)
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) else {
            XCTFail("AVAudioPCMBuffer should not be nil")
            return
        }
        
        do {
            try file.read(into: buffer)
        } catch {
            XCTFail("Error reading into buffer: \(error.localizedDescription)")
        }
        
        XCTAssertNotNil(buffer.audioBufferList.pointee.mBuffers.mData, "Audio buffer data should not be nil")
    }
}

