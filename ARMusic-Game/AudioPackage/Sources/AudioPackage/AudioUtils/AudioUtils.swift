// The Swift Programming Language
// https://docs.swift.org/swift-book

import simd
import Foundation

public class AudioUtils {
    public static var shared = AudioUtils()
    
    public var position: SIMD3<Float>?
    public var orientation: SIMD3<Float>?
    public var viewMatrix: simd_float4x4?
    
    
    public var BPM: Int = 5 {
        didSet {
            AudioTimerManager.shared.updateNoteDuration()
            AudioTimerManager.shared.updateTimerInterval()
            
        }
    }
    
    init() {}
    
}
