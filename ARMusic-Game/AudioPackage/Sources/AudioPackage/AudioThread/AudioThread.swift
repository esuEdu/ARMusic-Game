//
//  File.swift
//  
//
//  Created by Eduardo on 25/07/24.
//

import Foundation
import AVFoundation

public class AudioThread: Thread {
    
    private var audioPlayer: AVAudioPlayer?
    
    private var url: URL
    
    var isMuted: Bool = false
    var previousVolume: Float = 1.0
    
    public init(url: URL) {
        self.url = url
        super.init()
    }
    
    override public func main() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
            //keep the tread alive while audio is playing
            while audioPlayer?.isPlaying == true {
                Thread.sleep(forTimeInterval: 1)
                audioPlayer?.play()
            }
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
    
    public func playSound(url: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
    
    public func pause() {
        if let audioPlayer = audioPlayer {
            audioPlayer.pause()
        }
    }
    
    public func mute() {
        guard let player = audioPlayer else { return }
        isMuted = true
        previousVolume = player.volume
        player.volume = 0
    }

    public func unmute() {
        guard let player = audioPlayer else { return }
        isMuted = false
        player.volume = previousVolume
    }
    
    public func stopPlayback() {
        guard let player = audioPlayer else { return }
        player.stop()
    }
}
