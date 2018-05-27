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
    func testCallingPresentWelcomeMessage_CallsSpeakInSpeakerWithCorrectData() {
        // Given
        let speakerMock = SpeakerMock()
        sut.speaker = speakerMock
        
        // When
        sut.presentWelcomeMessage()
        
        // Then
        XCTAssertTrue(speakerMock.speakCalled)
        XCTAssertEqual(speakerMock.messagePassed, "Hello, please express your demand")
    }
    
    func testCallingPresentWeatherMessage_CallsSpeakInSpeakerWithCorrectData() {
        // Given
        let speakerMock = SpeakerMock()
        sut.speaker = speakerMock
        
        // When
        let response = AssistantViewModels.Response(temperature: 25, pressure: 1000, humidity: 50)
        sut.presentWeatherMessage(response: response)
        
        // Then
        XCTAssertTrue(speakerMock.speakCalled)
        XCTAssertEqual(speakerMock.messagePassed, "Current temperature in Berlin is 25 degrees celsius with pressure of 1000 Hectopascals and 50 percent humidity")
    }
}
