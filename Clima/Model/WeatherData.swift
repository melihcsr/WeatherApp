//
//  WeatherData.swift
//  Clima
//
//  Created by Melih Cesur on 13.09.2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation


struct WeatherData : Decodable {
    
    let name: String
    let weather : [Weather]
    let main : Main
    
    
}

struct Weather: Decodable {
    let id: Int
}

struct Main: Decodable {
    let temp: Double
}
