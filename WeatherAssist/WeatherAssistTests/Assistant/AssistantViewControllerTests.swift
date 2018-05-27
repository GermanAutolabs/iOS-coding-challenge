//
//  AssistantViewControllerTests.swift
//  WeatherAssistTests
//
//  Created by Bassel Ezzeddine on 26/05/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

@testable import WeatherAssist
import XCTest

class AssistantViewControllerTests: XCTestCase {
    
    // MARK: - Properties
    var window: UIWindow!
    var sut: AssistantViewController!
    
    // MARK: - Mocks
    class AssistantInteractorMock: AssistantViewControllerOut {
        var executeTasksWaitingViewToLoadCalled = false
        
        func executeTasksWaitingViewToLoad() {
            executeTasksWaitingViewToLoadCalled = true
        }
    }
    
    // MARK: - XCTestCase
    override func setUp() {
        super.setUp()
        window = UIWindow()
        setupSUT()
        loadView()
    }
    
    override func tearDown() {
        sut = nil
        window = nil
        super.tearDown()
    }
    
    // MARK: - Setup
    func setupSUT() {
        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        sut = storyboard.instantiateViewController(withIdentifier: "AssistantViewController") as! AssistantViewController
    }
    
    // MARK: - Methods
    func loadView() {
        window.addSubview(sut.view)
    }
    
    // MARK: - Tests
    func testWhenViewLoads_CallsExecuteTasksWaitingViewToLoadInInteractor() {
        // Given
        let interactorMock = AssistantInteractorMock()
        sut.interactor = interactorMock
        
        // When
        sut.viewDidLoad()
        
        // Then
        XCTAssertTrue(interactorMock.executeTasksWaitingViewToLoadCalled)
    }
}
