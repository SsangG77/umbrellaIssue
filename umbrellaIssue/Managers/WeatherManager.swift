//
//  WeatherManager.swift
//  umbrellaIssue
//
//  Created by 차상진 on 1/28/25.
//

import Foundation
import WeatherKit
import CoreLocation


struct currentWeather: Identifiable, Codable {
    let id = UUID()
    var temperature: Double     //온도
    var humnidity: Double       //습도
    var condition: String       //상태
    var precipitation: Double   //강수량
    
}



class WeatherManager {
    
    let weatherService = WeatherService()
    
    
    
    
    func getCurrentWeather(lat:Double, lon:Double) async -> currentWeather {
        
        let location = CLLocation(latitude: lat, longitude: lon)
        
            let weather = try! await weatherService.weather(for: location)
            
            let temp = weather.currentWeather.temperature.value
            let huminity = weather.currentWeather.humidity
            let condition = weather.currentWeather.condition.rawValue
            let precipitation = weather.currentWeather.precipitationIntensity.value
            
            let currentWeather = currentWeather(temperature: temp, humnidity: huminity, condition: condition, precipitation: precipitation)

            
            
            print("=============================")
//            print("온도 : \(temp)")
//            print("습도 : \(huminity)")
//            print("상태 : \(condition)")
//            print("강수량 : \(precipitation)")
            
            print("온도 : \(currentWeather.temperature)")
            print("습도 : \(currentWeather.humnidity)")
            print("상태 : \(currentWeather.condition)")
            print("강수량 : \(currentWeather.precipitation)")
            
            return currentWeather
        
    }
    
    
}
