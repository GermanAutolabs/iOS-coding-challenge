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
    private var weather: CityWeather?
    private let provider = MoyaProvider<WeatherApi>()
    private var icon: UIImage?
    
    
    
    /**
     Get Berliner weather from API 
     */
    func getWeather( completion: @escaping (_ error: Error?) -> Void)  {
        provider.request(.getWeather(cityName: "Berlin"), completion: { [weak self] (result) in
            switch result{
            case .success(let response):
                do{
                    let weather = try JSONDecoder().decode(CityWeather.self, from: response.data)
                    self?.weather = weather
                    completion(nil)
                }catch{
                    completion(error)
                }
            case .failure(let error):
                completion(error)
                print("Error")
            }
        })
    }
    
    /**
     Get weather icon from API
     */
    func getIconFromApi(){
        guard let iconName = weather?.weather.first?.icon else {return}
        self.provider.request(.getIcon(id: iconName), completion: { (result) in
            switch result{
            case .success(let response):
                do{
                    self.icon = UIImage(data: response.data) ?? UIImage()
                }catch{
                    self.icon = UIImage(named: "noIcon") ?? UIImage()
                    print("Error")
                }
            case .failure(let error):
                self.icon = UIImage(named: "noIcon") ?? UIImage()
                print("Error")
            }
        })
    }
    
    
    /**
     Returns weather icon to use in your ViewController
     */
    func getIcon()->UIImage{
        return self.icon ?? UIImage(named: "noIcon") ?? UIImage()
    }
    
    /**
     Returns Berliner weather to use in your ViewController
     */
    
    func getWeather()->String{
        return weather?.weather.first?.description ?? "Unavailable"
    }

}
