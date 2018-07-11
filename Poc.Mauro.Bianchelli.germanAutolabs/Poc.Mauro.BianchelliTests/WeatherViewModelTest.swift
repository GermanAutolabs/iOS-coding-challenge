//
//  WeatherViewModelTest.swift
//  Poc.Mauro.BianchelliTests
//
//  Created by Mauro on 11/7/18.
//  Copyright © 2018 Mauro. All rights reserved.
//

import XCTest

@testable import Poc_Mauro_Bianchelli

class WeatherViewModelTest: XCTestCase {
    
    private var viewModel: WeatherViewModel?
    
    override func setUp() {
        viewModel = WeatherViewModel()
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    
    func testGetWeatherFromApi(){
        let e = expectation(description: "API")
        viewModel?.getWeather(completion: {(error) in
            XCTAssertNil(error)
            e.fulfill()
        })
        waitForExpectations(timeout: 5.0, handler: nil)

    }
    
    
    func testGetIcon(){
        XCTAssertNotNil(viewModel?.getIcon())
    }
    
    func testgetWeather(){
        XCTAssertNotNil(viewModel?.getWeather())
    }

    
}
