// The Swift Programming Language
// https://docs.swift.org/swift-book

public class AudioUtils {
    public static var shared = AudioUtils()
    
    public var possition: SIMD3<Float>?
    public var orientation: SIMD3<Float>?
    
    init() {}
    
}
