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
        var presentWelcomeMessageCalled = false
        
        var presentWeatherMessageCalled = false
        var presentWeatherMessageResponse: AssistantViewModels.Response?
        
        func presentWelcomeMessage() {
            presentWelcomeMessageCalled = true
        }
        
        func presentWeatherMessage(response: AssistantViewModels.Response) {
            presentWeatherMessageCalled = true
            presentWeatherMessageResponse = response
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
        var getWeatherResponseToBeReturned: GetWeatherResponse?
        var successToBeReturned = false
        
        override func fetchCurrentWeather(completionHandler: @escaping(_ getWeatherResponse: GetWeatherResponse?, _ success: Bool) -> Void) {
            fetchCurrentWeatherCalled = true
            completionHandler(getWeatherResponseToBeReturned, successToBeReturned)
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
    func testCallingExecuteTasksWaitingViewToLoad_CallsPresentWelcomeMessageInPresenter() {
        // Given
        let presenterMock = AssistantPresenterMock()
        sut.presenter = presenterMock
        
        // When
        sut.executeTasksWaitingViewToLoad()
        
        // Then
        XCTAssertTrue(presenterMock.presentWelcomeMessageCalled)
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
    
    func testCallingStartListeningToUserAndRecognizingWords_CallsPresentWeatherMessageInPresenterWithCorrectData_WhenResponseFromWorkerIsSuccessAndIsNotNil() {
        // Given
        let voiceListenerMock = VoiceListenerMock()
        sut.voiceListener = voiceListenerMock
        
        let workerMock = WeatherWorkerMock()
        sut.worker = workerMock
        
        let presenterMock = AssistantPresenterMock()
        sut.presenter = presenterMock
        
        // When
        let main = GetWeatherResponse.Main(temp: 350, pressure: 1000, humidity: 50)
        workerMock.getWeatherResponseToBeReturned = GetWeatherResponse(main: main)
        workerMock.successToBeReturned = true
        
        voiceListenerMock.recognizedWordToBeReturned = "Weather"
        sut.startListeningToUserAndRecognizingWords()
        
        // Then
        XCTAssertTrue(presenterMock.presentWeatherMessageCalled)
        XCTAssertEqual(presenterMock.presentWeatherMessageResponse?.temperature, 350)
        XCTAssertEqual(presenterMock.presentWeatherMessageResponse?.pressure, 1000)
        XCTAssertEqual(presenterMock.presentWeatherMessageResponse?.humidity, 50)
    }
}
