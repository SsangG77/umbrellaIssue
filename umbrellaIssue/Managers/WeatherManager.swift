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
    var temperature: Double     //온도
    var humnidity: Double       //습도
    var condition: String       //상태
    var precipitation: Double   //강수량
    var isDaylight: Bool
    
}

struct HourWeather: Identifiable, Codable {
    let id = UUID()
    var time: String
    var weatherType: WeatherType
    var precipitationAmount: Double
    var temperature: Int
    var isDayNight: Bool
    var symbolName: String
    
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
        let isDaylight = weather.currentWeather.isDaylight
        
 
        let currentWeather = currentWeather(
            temperature: temp,
            humnidity: huminity,
            condition: condition,
            precipitation: precipitation,
            isDaylight: isDaylight
        )

//            print("=============================")
//            
//            print("온도 : \(currentWeather.temperature)")
//            print("습도 : \(currentWeather.humnidity)")
//            print("상태 : \(currentWeather.condition)")
//            print("강수량 : \(currentWeather.precipitation)")
            
            return currentWeather
    }
    
    
    func getTodayWeather(lat:Double, lon:Double) async -> [HourWeather] {
        let location = CLLocation(latitude: lat, longitude: lon)
        
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR") // 한국 시간 기준 (오전/오후 한글)
        formatter.dateFormat = "a h" // 'a'는 오전/오후, 'h'는 12시간제 시간
        
        
        
        
        let weather = try! await weatherService.weather(for: location)
        
        print("=====================================================")
        
        
        var hourWeathers:[HourWeather] = []
        
        weather.hourlyForecast.forEach { h in
            var now = Date()
            
            if now <= h.date && h.date <= now.addingTimeInterval(3600 * 24) {
                print("-----------------------------------------------------")
                
                print("date format : ", formatter.string(from: h.date))
                
                
                //날씨 정보는 위경도 기준
                print("condition : ", h.condition)
                
                var weather:WeatherType = .sunny
                if h.condition == .drizzle,
                    h.condition == .heavyRain,
                    h.condition == .rain,
                    h.condition == .isolatedThunderstorms,
                    h.condition == .sunShowers,
                    h.condition == .scatteredThunderstorms,
                   h.condition == .thunderstorms
                {
                    weather = .rain
                }
                else if h.condition == .flurries,
                        h.condition == .snow,
                        h.condition == .sleet,
                        h.condition == .sunFlurries,
                        h.condition == .wintryMix,
                        h.condition == .blizzard,
                        h.condition == .heavySnow
                {
                    weather = .snow
                }
                else if h.condition == .mostlyCloudy,
                        h.condition == .partlyCloudy,
                        h.condition == .cloudy
                {
                    weather = .cloud
                }
                
                print("temp : ", Int(h.temperature.value))
                print("symbol name : ", h.symbolName)
                print("강수량 : ", h.precipitationAmount.value)
                print("강설량 : ", h.snowfallAmount.value)
                print("낮/밤 : ", h.isDaylight)
                
                var hourWeather = HourWeather(
                    time: formatter.string(from: h.date),
                    weatherType: weather,
                    precipitationAmount: weather == .snow ? h.snowfallAmount.value : h.precipitationAmount.value ,
                    temperature: Int(h.temperature.value),
                    isDayNight: h.isDaylight,
                    symbolName: h.symbolName
                )
                
                
                hourWeathers.append(hourWeather)
                
                
            }//if
            
        }//for
        
        
        
        
        return hourWeathers
        
    }
  
        
    
    
}
