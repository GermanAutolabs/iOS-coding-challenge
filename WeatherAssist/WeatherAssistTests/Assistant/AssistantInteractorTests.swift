//
//  AssistantInteractorTests.swift
//  WeatherAssistTests
//
//  Created by Bassel Ezzeddine on 26/05/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

@testable import WeatherAssist
import XCTest

class AssistantInteractorTests: XCTestCase {
    
    // MARK: - Properties
    var sut: AssistantInteractor!
    
    // MARK: - Mocks
    class AssistantPresenterMock: AssistantInteractorOut {
    }
    
    class SpeakerMock: Speaker {
        var speakCalled = false
        var messagePassed = ""
        
        override func speak(message: String) {
            speakCalled = true
            messagePassed = message
        }
    }
    
    class InteractorMock: AssistantInteractor {
        var playWelcomeMessageCalled = false
        
        override func playWelcomeMessage() {
            playWelcomeMessageCalled = true
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
        sut = AssistantInteractor()
    }
    
    // MARK: - Tests
    func testCallingExecuteTasksWaitingViewToLoad_CallsPlayWelcomeMessage() {
        // Given
        let interactorMock = InteractorMock()
        sut = interactorMock
        
        // When
        sut.executeTasksWaitingViewToLoad()
        
        // Then
        XCTAssertTrue(interactorMock.playWelcomeMessageCalled)
    }
    
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
