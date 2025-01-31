//
//  WeatherManager.swift
//  umbrellaIssue
//
//  Created by 차상진 on 1/28/25.
//

import Foundation
import WeatherKit
import CoreLocation


enum WeatherType: Codable {
    case rain, snow, cloud, sunny, dust, other
}


struct currentWeather: Identifiable, Codable {
    var id = UUID()
    var temperature: Int     //온도
    var humnidity: Int       //습도
    var precipitation: String   //강수량
    var isDaylight: Bool
    var symbolName: String
    var weatherType: WeatherType
    
}

struct HourWeather: Identifiable, Codable {
    var id = UUID()
    var time: String
    var weatherType: WeatherType
    var precipitation: String
    var temperature: Int
    var isDaylight: Bool
    var symbolName: String
    
}

struct WeakWeather: Identifiable, Codable {
    var id = UUID()
    var date: String
    var weak: String
    var weatherType: WeatherType
    var precipitation: String
    var highTemp: String
    var lowTemp: String
    
}



class WeatherManager {
    
    let weatherService = WeatherService()
    
    
    
    
    func getCurrentWeather(lat:Double, lon:Double) async -> currentWeather {
        
        let location = CLLocation(latitude: lat, longitude: lon)
        
        let weather = try! await weatherService.weather(for: location)
        
        let temp = Int(weather.currentWeather.temperature.value)
        let huminity = Int(weather.currentWeather.humidity * 100)
        let condition = weather.currentWeather.condition
        let precipitation =  Double(round(weather.currentWeather.precipitationIntensity.value * 10) / 10)
        let isDaylight = weather.currentWeather.isDaylight
        let symbolName = weather.currentWeather.symbolName
 
        var weatherType:WeatherType = .sunny
        if condition == .drizzle ||
            condition == .heavyRain ||
            condition == .rain ||
            condition == .isolatedThunderstorms ||
            condition == .sunShowers ||
            condition == .scatteredThunderstorms ||
           condition == .thunderstorms
        {
            weatherType = .rain
        }
        else if condition == .flurries ||
                condition == .snow ||
                condition == .sleet ||
                condition == .sunFlurries ||
                condition == .wintryMix ||
                condition == .blizzard ||
                condition == .heavySnow
        {
            weatherType = .snow
        }
        else if condition == .mostlyCloudy ||
                condition == .partlyCloudy ||
                condition == .cloudy
        {
            weatherType = .cloud
        } else {
            weatherType = .sunny
        }
        
        let currentWeather = currentWeather(
            temperature: temp,
            humnidity: huminity,
            precipitation: String(format: "%.1f", precipitation),
            isDaylight: isDaylight,
            symbolName: symbolName,
            weatherType: weatherType
        )
        
        return currentWeather
    }
    
    
    
    
    
    
    
    
    
    func getTodayWeather(lat:Double, lon:Double) async -> [HourWeather] {
        let location = CLLocation(latitude: lat, longitude: lon)
        
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR") // 한국 시간 기준 (오전/오후 한글)
        formatter.dateFormat = "a h" // 'a'는 오전/오후, 'h'는 12시간제 시간
        
        
        
        
        let weather = try! await weatherService.weather(for: location)
        
//        print("=====================================================")
        
        
        var hourWeathers:[HourWeather] = []
        
        weather.hourlyForecast.forEach { h in
            let now = Date()
            
            if now <= h.date && h.date <= now.addingTimeInterval(3600 * 24) {
               
                
                var weather:WeatherType = .sunny
                if h.condition == .drizzle ||
                    h.condition == .heavyRain ||
                    h.condition == .rain ||
                    h.condition == .isolatedThunderstorms ||
                    h.condition == .sunShowers ||
                    h.condition == .scatteredThunderstorms ||
                   h.condition == .thunderstorms
                {
                    weather = .rain
                }
                else if h.condition == .flurries ||
                        h.condition == .snow ||
                        h.condition == .sleet ||
                        h.condition == .sunFlurries ||
                        h.condition == .wintryMix ||
                        h.condition == .blizzard ||
                        h.condition == .heavySnow
                {
                    weather = .snow
                }
                else if h.condition == .mostlyCloudy ||
                        h.condition == .partlyCloudy ||
                        h.condition == .cloudy
                {
                    weather = .cloud
                } else {
                    weather = .sunny
                }
                
                
                
                
                let hourWeather = HourWeather(
                    time: formatter.string(from: h.date),
                    weatherType: weather,
                    precipitation:
                        weather == .snow ?
                    String(format: "%.1f", Double(round(h.snowfallAmount.value * 10) / 10)) : String(format: "%.1f", Double(round(h.precipitationAmount.value * 10) / 10)) ,
                    temperature: Int(h.temperature.value),
                    isDaylight: h.isDaylight,
                    symbolName: h.symbolName
                )
            
                
                hourWeathers.append(hourWeather)
                
                
            }//if
            
        }//for
        
        
        return hourWeathers
        
    }//
    
    
    
    func getWeakWeather(lat:Double, lon:Double) async {
        let location = CLLocation(latitude: lat, longitude: lon)
       
        
        
        let weather = try! await weatherService.weather(for: location)
        
        weather.dailyForecast.forEach { d in
            print("==============================================================")
            print(d)
            print("-----------------")
            print(d.date)
            print(d.condition)
            print(d.precipitationAmount)
            print(d.highTemperature)
            print(d.lowTemperature)
            
        }
    }
  
        
    
    
}
