//
//  AudioDataTests.swift
//  
//
//  Created by Eduardo on 24/07/24.
//

import XCTest
@testable import DataPackage

// Define a final class for audio data tests
final class AudioDataTests: XCTestCase {

    // Test function to verify filename generation
    func testFileNameGeneration() {
        // Create an instance of AudioData with instrument 'piano' and note 'c'
        let audioData = AudioData(instrument: .piano, note: .c)
        // Assert that the generated filename matches the expected value "piano_C"
        XCTAssertEqual(audioData.fileName, "piano_C", "The filename should be 'piano_C'")
    }

    // Test function to verify URL generation
    func testURLGeneration() {
        // Create an instance of AudioData with instrument 'piano' and note 'c'
        let audioData = AudioData(instrument: .piano, note: .c)
        // Get the URL from the audioData instance
        let url = audioData.getURL()
        
        // Assert that the URL is not nil
        XCTAssertNotNil(url, "The URL should not be nil")
        
        // If the URL is not nil, check if the file exists at the given URL path
        if let url = url {
            let fileExists = FileManager.default.fileExists(atPath: url.path)
            // Assert that the file "piano_C.mpeg" exists at the specified URL
            XCTAssertTrue(fileExists, "The file 'piano_C.mpeg' should exist at the URL")
        }
    }
}

// Define a class for audio data performance tests
class AudioDataPerformanceTests: XCTestCase {

    // Test function to measure performance of URL generation
    func testURLGenerationPerformance() {
        // Create an instance of AudioData with instrument 'piano' and note 'c'
        let audioData = AudioData(instrument: .piano, note: .c)
        
        // Measure the performance of generating the URL 1000 times
        self.measure {
            for _ in 0..<1000 {
                _ = audioData.getURL()
            }
        }
    }
}
