//
//  WeatherManager.swift
//  Clima
//
//  Created by Melih Cesur on 12.09.2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager:WeatherManager,weather:WeatherModel)
    func didFailWithError(error : Error)
}



struct WeatherManager{
    
    var delegate : WeatherManagerDelegate?
    
    
    var url = "https://api.openweathermap.org/data/2.5/weather?appid=5f0cdc2c0337bda34abca2c0b593adc0&units=metric&q="
    var urlWeatherManager = "https://api.openweathermap.org/data/2.5/weather?appid=5f0cdc2c0337bda34abca2c0b593adc0&units=metric"
    
    mutating func completeUrl(city : String){
        url = "https://api.openweathermap.org/data/2.5/weather?appid=5f0cdc2c0337bda34abca2c0b593adc0&units=metric&q=\(city)"
        
       performRequest(with: url)
    }
    
    
    func fetchWeather(latidute : CLLocationDegrees, longitute : CLLocationDegrees){
        let urlString = "\(urlWeatherManager)&lat=\(latidute)&lon=\(longitute)"
        performRequest(with: urlString)
    }
    
    
    
    
    func performRequest(with urlString : String){
        
        if let url = URL(string: urlString){
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(weatherData: safeData){
                        self.delegate?.didUpdateWeather(self,weather:weather)
                    }
                }
            }
            
            task.resume()
            
        }
        
    }
    
    func parseJSON(weatherData : Data) -> WeatherModel? {
        
        let decoder = JSONDecoder()
        
        do{
           let decodedData =  try decoder.decode(WeatherData.self, from: weatherData)
           let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
          
        } catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    
    }
    
   
    
    
}

