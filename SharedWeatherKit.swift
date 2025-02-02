//
//  SharedWeatherKit.swift
//  umbrellaIssue
//
//  Created by 차상진 on 2/1/25.
//


import Foundation
import WeatherKit
import CoreLocation



public enum WeatherType: String, Codable {
    case rain, snow, cloud, sunny, dust, other
}


public struct currentWeather: Identifiable, Codable {
    public var id = UUID()
    public var temperature: Int     //온도
    public var humnidity: Int       //습도
    public var precipitation: String   //강수량
    public var isDaylight: Bool
    public var symbolName: String
    public var weatherType: WeatherType
    
    public init(id: UUID = UUID(),
                   temperature: Int,
                   humnidity: Int,
                   precipitation: String,
                   isDaylight: Bool,
                   symbolName: String,
                   weatherType: WeatherType) {
            self.id = id
            self.temperature = temperature
            self.humnidity = humnidity
            self.precipitation = precipitation
            self.isDaylight = isDaylight
            self.symbolName = symbolName
            self.weatherType = weatherType
        }
    
}

public struct HourWeather: Identifiable, Codable {
    public var id = UUID()
    public var time: String
    public var weatherType: WeatherType
    public var precipitation: String
    public var temperature: Int
    public var isDaylight: Bool
    public var symbolName: String
    
}

public struct WeekWeather: Identifiable, Codable {
    public var id = UUID()
    public var date: Int
    public var weak: String
    public var weatherType: WeatherType
    public var precipitation: String
    public var highTemp: Int
    public var lowTemp: Int
    
}

public class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    public let defaults = UserDefaults(suiteName: "group.com.sangjin.umbrellaWidget") // 앱 그룹 설정
    
    private var locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    @Published public var location: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus?
    @Published public var locality: String = "위치 불러오는 중..."  // 🆕 지역명 추가

    public override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    
    

//    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        authorizationStatus = status
//        if status == .authorizedWhenInUse || status == .authorizedAlways {
//            manager.requestLocation()
//        }
//    }

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            authorizationStatus = status
            if status == .authorizedWhenInUse || status == .authorizedAlways {
                manager.requestLocation()
                defaults?.set(true, forKey: "LocationPermissionGranted") // 위치 권한이 할당되었음을 저장
            } else {
                defaults?.set(false, forKey: "LocationPermissionGranted") // 위치 권한이 할당되지 않았음을 저장
            }
        }
    
    
    public func requestLocation() {
        locationManager.requestLocation()
    }
    
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let newLocation = locations.first {
                    location = newLocation
                    fetchLocality(from: newLocation) // 🆕 위치 정보 가져올 때 지역명도 가져오기
                }
    }
       
    
    
    
    
    
 
   

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("위치 업데이트 실패: \(error.localizedDescription)")
    }
    
    private func fetchLocality(from location: CLLocation) {
           geocoder.reverseGeocodeLocation(location) { placemarks, error in
               if let error = error {
                   print("지역명 가져오기 실패: \(error.localizedDescription)")
                   self.locality = "위치 정보 없음"
                   return
               }
               
               if let placemark = placemarks?.first {
                   DispatchQueue.main.async {
                       self.locality = placemark.administrativeArea ?? "알 수 없음" // ex) 서울특별시
                       if let city = placemark.locality {
                           self.locality = city // ex) 부산광역시
                       }
                   }
               }
           }
       }
}


public class WeatherManager {
    
    public init() {
            // 초기화 코드가 있다면 여기에
        }
    
    let weatherService = WeatherService()
    
    public let defaults = UserDefaults(suiteName: "group.com.sangjin.umbrellaWidget") // 앱 그룹 설정


    /// 🌟 현재 날씨 가져오기
    public func getCurrentWeather(location: CLLocation) async -> currentWeather? {
        do {
            let weather = try await weatherService.weather(for: location)
            
            let weatherType = getWeatherType(condition: weather.currentWeather.condition)
            print("현재 날씨 가져오기 \(weatherType)")
           // saveWeatherType(weatherType: weatherType) // 날씨 타입 저장
            
            return currentWeather(
                temperature: Int(weather.currentWeather.temperature.value),
                humnidity: Int(weather.currentWeather.humidity * 100),
                precipitation: String(format: "%.1f", weather.currentWeather.precipitationIntensity.value),
                isDaylight: weather.currentWeather.isDaylight,
                symbolName: weather.currentWeather.symbolName,
                weatherType: getWeatherType(condition: weather.currentWeather.condition)
            )
        } catch {
            print("현재 날씨 가져오기 오류: \(error)")
            return nil
        }
    }

    /// 🌟 시간별 날씨 가져오기
    public func getTodayWeather(location: CLLocation) async -> [HourWeather] {
        do {
            let weather = try await weatherService.weather(for: location)
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.dateFormat = "a h"

            return weather.hourlyForecast.compactMap { h in
                let now = Date()
                if now <= h.date && h.date <= now.addingTimeInterval(3600 * 24) {
                    return HourWeather(
                        time: formatter.string(from: h.date),
                        weatherType: getWeatherType(condition: h.condition),
                        precipitation: String(format: "%.1f", h.precipitationAmount.value),
                        temperature: Int(h.temperature.value),
                        isDaylight: h.isDaylight,
                        symbolName: h.symbolName
                    )
                }
                return nil
            }
        } catch {
            print("시간별 날씨 가져오기 오류: \(error)")
            return []
        }
    }

    /// 🌟 주간 날씨 가져오기
    public func getWeekWeather(location: CLLocation) async -> [WeekWeather] {
        do {
            let weather = try await weatherService.weather(for: location)
            return weather.dailyForecast.map { d in
                WeekWeather(
                    date: getDay(d: d.date),
                    weak: getWeek(d: d.date),
                    weatherType: getWeatherType(condition: d.condition),
                    precipitation: String(format: "%.1f", d.precipitationAmount.value),
                    highTemp: Int(d.highTemperature.value),
                    lowTemp: Int(d.lowTemperature.value)
                )
            }
        } catch {
            print("주간 날씨 가져오기 오류: \(error)")
            return []
        }
    }

    /// 🌟 날씨 타입 변환
    private func getWeatherType(condition: WeatherCondition) -> WeatherType {
        switch condition {
        case .drizzle, .heavyRain, .rain, .isolatedThunderstorms, .sunShowers, .scatteredThunderstorms, .thunderstorms:
            return .rain
        case .flurries, .snow, .sleet, .sunFlurries, .wintryMix, .blizzard, .heavySnow:
            return .snow
        case .mostlyCloudy, .partlyCloudy, .cloudy:
            return .cloud
        default:
            return .sunny
        }
    }

    /// 🌟 날짜 변환
    private func getDay(d: Date) -> Int {
        return Calendar.current.component(.day, from: d)
    }

    private func getWeek(d: Date) -> String {
        let weekdays = ["일", "월", "화", "수", "목", "금", "토"]
        return weekdays[Calendar.current.component(.weekday, from: d) - 1]
    }
}

