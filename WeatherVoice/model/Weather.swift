//
//  Weather.swift
//  WeatherVoice
//
//  Created by Ed Negro on 02.10.18.
//  Copyright © 2018 Etienne Negro. All rights reserved.
//
struct Conditions: Codable {
    let main: String
    let description: String
    let icon: String

    enum CodingKeys: String, CodingKey {
        case main
        case description
        case icon
    }
}

struct Weather: Codable {
    let tempC: Int
    let humidity: Int
    let type: String
    let desc: String
    let windspeedMps: Float
    let name: String
    let icon: String

    private enum CodingKeys: String, CodingKey {
        case main
        case tempC = "temp"
        case humidity

        case wind
        case windspeedMps = "speed"

        case name
        case conditions = "weather"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? "unknown"

        let mainContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .main)
        tempC = Int(try mainContainer.decodeIfPresent(Float.self, forKey: .tempC) ?? -1)
        humidity = Int(try mainContainer.decodeIfPresent(Float.self, forKey: .humidity) ?? -1)

        let windContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .wind)
        windspeedMps = try windContainer.decodeIfPresent(Float.self, forKey: .windspeedMps) ?? -1

        let conditions = try container.decodeIfPresent([Conditions].self, forKey: .conditions)
        type = conditions?.first?.main ?? "unknown"
        desc = conditions?.first?.description ?? "unknown"
        icon = conditions?.first?.icon ?? ""
    }

    func encode(to encoder: Encoder) throws { }
}
