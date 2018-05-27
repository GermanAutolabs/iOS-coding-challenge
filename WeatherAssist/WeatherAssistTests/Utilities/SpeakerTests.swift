//
//  SpeakerTests.swift
//  WeatherAssistTests
//
//  Created by Bassel Ezzeddine on 26/05/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

@testable import WeatherAssist
import XCTest
import Speech

class SpeakerTests: XCTestCase {
    
    // MARK: - Properties
    var sut: Speaker!
    
    // MARK: - Mocks
    class SynthesizerMock: AVSpeechSynthesizer {
        var speakCalled = false
        var speechStringPassed = ""
        
        override func speak(_ utterance: AVSpeechUtterance) {
            speakCalled = true
            speechStringPassed = utterance.speechString
        }
    }
    
    // MARK: - XCTestCase
    override func setUp() {
        super.setUp()
        setupSUT()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Setup
    func setupSUT() {
        sut = Speaker()
    }
    
    // MARK: - Tests
    func testCallingSpeakInSpeaker_CallsSpeakInSynthesizerWithCorrectData() {
        // Given
        let synthesizerMock = SynthesizerMock()
        sut.synthesizer = synthesizerMock
        
        // When
        sut.speak(message: "Hello")
        
        // Then
        XCTAssertTrue(synthesizerMock.speakCalled)
        XCTAssertEqual(synthesizerMock.speechStringPassed, "Hello")
    }
}
