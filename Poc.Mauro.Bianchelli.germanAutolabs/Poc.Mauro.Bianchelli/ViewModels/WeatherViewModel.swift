//
//  TableViewModel.swift
//  Poc.Mauro.Bianchelli
//
//  Created by Mauro on 07/7/18.
//  Copyright © 2018 Mauro. All rights reserved.
//

import Foundation
import Moya

class WeatherViewModel {
//    var weather: Observable<CityWeather?> = Observable(nil)
    var weather: CityWeather?
    var provider = MoyaProvider<WeatherApi>()
    
    func getWeather( completion: @escaping (_ weather: CityWeather?) -> Void)  {
        provider.request(.getWeather(cityName: "Berlin"), completion: { [weak self] (result) in
            switch result{
            case .success(let response):
                do{
                    let weather = try JSONDecoder().decode(CityWeather.self, from: response.data)
                    self?.weather = weather
                    completion(weather)
                }catch{
                    print("Error")
                }
            case .failure(let error):
                print("Error")
            }
        })
    }

}
