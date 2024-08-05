//
//  File.swift
//
//
//  Created by Eduardo on 30/07/24.
//

import Foundation

public struct FixedSizeBoolArray {
    private var boolArray: [Bool]
    private let size: Int
    
    init(size: Int, initialValue: Bool = false) {
        self.size = size
        self.boolArray = [Bool](repeating: initialValue, count: size)
    }
    
    public func getValue(at index: Int) -> Bool? {
        guard index >= 0 && index < size else { return nil }
        return boolArray[index]
    }
    
    public mutating func setValue(_ value: Bool, at index: Int) {
        guard index >= 0 && index < size else { return }
        boolArray[index] = value
    }
    
    public mutating func toggleValue(at index: Int)  {
        guard index >= 0 && index < size else { return }
        boolArray[index].toggle()
    }
    
    public mutating func toggleValues(at indices: Set<Int>) {
        boolArray = [Bool](repeating: false, count: size)
        
        indices.forEach { index in
            if index >= 0 && index < size {
                boolArray[index] = true
            }
        }
    }
    
    public mutating func setAllValues(to value: Bool) {
        for i in 0..<size {
            boolArray[i] = value
        }
    }
    
    public func getArray() -> [Bool] {
        return boolArray
    }
}
