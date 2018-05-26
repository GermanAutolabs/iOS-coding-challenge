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
        var playWelcomeMessageCalled = false
        
        func playWelcomeMessage() {
            playWelcomeMessageCalled = true
        }
    }
    
    class VoiceListenerMock: VoiceListener {
        var setupVoiceListeningCalled = false
        
        override func setupVoiceListening() {
            setupVoiceListeningCalled = true
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
    func testCallingExecuteTasksWaitingViewToLoad_CallsPlayWelcomeMessageInPresenter() {
        // Given
        let presenterMock = AssistantPresenterMock()
        sut.presenter = presenterMock
        
        // When
        sut.executeTasksWaitingViewToLoad()
        
        // Then
        XCTAssertTrue(presenterMock.playWelcomeMessageCalled)
    }
    
    func testCallingExecuteTasksWaitingViewToLoad_CallsSetupVoiceListeningInVoiceListener() {
        // Given
        let voiceListenerMock = VoiceListenerMock()
        sut.voiceListener = voiceListenerMock
        
        // When
        sut.executeTasksWaitingViewToLoad()
        
        // Then
        XCTAssertTrue(voiceListenerMock.setupVoiceListeningCalled)
    }
}
