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
        var isSuccessfulToBeReturned = false
        
        var startListeningCalled = false
        var recognizedWordToBeReturned = ""
        
        override func setupVoiceListening(completionHandler: @escaping(_ isSuccessful: Bool) -> Void) {
            setupVoiceListeningCalled = true
            completionHandler(isSuccessfulToBeReturned)
        }
        
        override func startListening(completionHandler: @escaping (_ recognizedWord: String) -> Void) {
            startListeningCalled = true
            completionHandler(recognizedWordToBeReturned)
        }
    }
    
    class WeatherWorkerMock: WeatherWorker {
        var fetchCurrentWeatherCalled = false
        
        override func fetchCurrentWeather(completionHandler: @escaping(_ getWeatherResponse: GetWeatherResponse?, _ success: Bool) -> Void) {
            fetchCurrentWeatherCalled = true
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
    
    func testCallingExecuteTasksWaitingViewToLoad_CallsStartListeningInVoiceListener_WhenSetupVoiceListeningIsSuccessful() {
        // Given
        let voiceListenerMock = VoiceListenerMock()
        sut.voiceListener = voiceListenerMock
        
        // When
        voiceListenerMock.isSuccessfulToBeReturned = true
        sut.executeTasksWaitingViewToLoad()
        
        // Then
        XCTAssertTrue(voiceListenerMock.startListeningCalled)
    }
    
    func testCallingStartListeningToUserAndRecognizingWords_CallsFetchCurrentWeatherInWorker_WhenRecognizedWordIsWeather() {
        // Given
        let voiceListenerMock = VoiceListenerMock()
        sut.voiceListener = voiceListenerMock
        
        let workerMock = WeatherWorkerMock()
        sut.worker = workerMock
        
        // When
        voiceListenerMock.recognizedWordToBeReturned = "Weather"
        sut.startListeningToUserAndRecognizingWords()
        
        // Then
        XCTAssertTrue(workerMock.fetchCurrentWeatherCalled)
    }
}
