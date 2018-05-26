//
//  AssistantPresenterTests.swift
//  WeatherAssistTests
//
//  Created by Bassel Ezzeddine on 26/05/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

@testable import WeatherAssist
import XCTest

class AssistantPresenterTests: XCTestCase {
    
    // MARK: - Properties
    var sut: AssistantPresenter!
    
    // MARK: - Mocks
    class AssistantViewControllerMock: AssistantPresenterOut {
    }
    
    class SpeakerMock: Speaker {
        var speakCalled = false
        var messagePassed = ""
        
        override func speak(message: String) {
            speakCalled = true
            messagePassed = message
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
        sut = AssistantPresenter()
    }
    
    // MARK: - Tests
    func testCallingPlayWelcomeMessage_CallsSpeakInSpeaker_WithCorrectData() {
        // Given
        let speakerMock = SpeakerMock()
        sut.speaker = speakerMock
        
        // When
        sut.playWelcomeMessage()
        
        // Then
        XCTAssertTrue(speakerMock.speakCalled)
        XCTAssertEqual(speakerMock.messagePassed, "Hello, please express your demand")
    }
}
