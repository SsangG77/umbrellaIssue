////
////  WeatherManager.swift
////  umbrellaIssue
////
////  Created by 차상진 on 1/28/25.
////
//
//import Foundation
//import WeatherKit
//import CoreLocation
//
//
//enum WeatherType: String, Codable {
//    case rain, snow, cloud, sunny, dust, other
//}
//
//
//struct currentWeather: Identifiable, Codable {
//    var id = UUID()
//    var temperature: Int     //온도
//    var humnidity: Int       //습도
//    var precipitation: String   //강수량
//    var isDaylight: Bool
//    var symbolName: String
//    var weatherType: WeatherType
//    
//}
//
//struct HourWeather: Identifiable, Codable {
//    var id = UUID()
//    var time: String
//    var weatherType: WeatherType
//    var precipitation: String
//    var temperature: Int
//    var isDaylight: Bool
//    var symbolName: String
//    
//}
//
//struct WeekWeather: Identifiable, Codable {
//    var id = UUID()
//    var date: Int
//    var weak: String
//    var weatherType: WeatherType
//    var precipitation: String
//    var highTemp: Int
//    var lowTemp: Int
//    
//}
//
//class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
//    private var locationManager = CLLocationManager()
//    private let geocoder = CLGeocoder()
//    
//    @Published var location: CLLocation?
//    @Published var authorizationStatus: CLAuthorizationStatus?
//    @Published var locality: String = "위치 불러오는 중..."  // 🆕 지역명 추가
//
//    override init() {
//        super.init()
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestWhenInUseAuthorization()
//    }
//    
//    func requestLocation() {
//        locationManager.requestLocation()
//    }
//
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        authorizationStatus = status
//        if status == .authorizedWhenInUse || status == .authorizedAlways {
//            manager.requestLocation()
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let newLocation = locations.first {
//                    location = newLocation
//                    fetchLocality(from: newLocation) // 🆕 위치 정보 가져올 때 지역명도 가져오기
//                }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("위치 업데이트 실패: \(error.localizedDescription)")
//    }
//    
//    private func fetchLocality(from location: CLLocation) {
//           geocoder.reverseGeocodeLocation(location) { placemarks, error in
//               if let error = error {
//                   print("지역명 가져오기 실패: \(error.localizedDescription)")
//                   self.locality = "위치 정보 없음"
//                   return
//               }
//               
//               if let placemark = placemarks?.first {
//                   DispatchQueue.main.async {
//                       self.locality = placemark.administrativeArea ?? "알 수 없음" // ex) 서울특별시
//                       if let city = placemark.locality {
//                           self.locality = city // ex) 부산광역시
//                       }
//                   }
//               }
//           }
//       }
//}
//
//
//class WeatherManager {
//    let weatherService = WeatherService()
//    
//    let defaults = UserDefaults(suiteName: "group.com.sangjin.umbrellaIssue") // 앱 그룹 설정
//    
//    func saveWeatherType(weatherType: WeatherType) {
//        print("saveWeatherType() = \(weatherType)")
//        defaults?.set(weatherType.rawValue, forKey: "weatherType") // Enum을 문자열로 저장
//        }
//
//    /// 🌟 현재 날씨 가져오기
//    func getCurrentWeather(location: CLLocation) async -> currentWeather? {
//        do {
//            let weather = try await weatherService.weather(for: location)
//            
//            let weatherType = getWeatherType(condition: weather.currentWeather.condition)
//            saveWeatherType(weatherType: weatherType) // 날씨 타입 저장
//            
//            return currentWeather(
//                temperature: Int(weather.currentWeather.temperature.value),
//                humnidity: Int(weather.currentWeather.humidity * 100),
//                precipitation: String(format: "%.1f", weather.currentWeather.precipitationIntensity.value),
//                isDaylight: weather.currentWeather.isDaylight,
//                symbolName: weather.currentWeather.symbolName,
//                weatherType: getWeatherType(condition: weather.currentWeather.condition)
//            )
//        } catch {
//            print("현재 날씨 가져오기 오류: \(error)")
//            return nil
//        }
//    }
//
//    /// 🌟 시간별 날씨 가져오기
//    func getTodayWeather(location: CLLocation) async -> [HourWeather] {
//        do {
//            let weather = try await weatherService.weather(for: location)
//            let formatter = DateFormatter()
//            formatter.locale = Locale(identifier: "ko_KR")
//            formatter.dateFormat = "a h"
//
//            return weather.hourlyForecast.compactMap { h in
//                let now = Date()
//                if now <= h.date && h.date <= now.addingTimeInterval(3600 * 24) {
//                    return HourWeather(
//                        time: formatter.string(from: h.date),
//                        weatherType: getWeatherType(condition: h.condition),
//                        precipitation: String(format: "%.1f", h.precipitationAmount.value),
//                        temperature: Int(h.temperature.value),
//                        isDaylight: h.isDaylight,
//                        symbolName: h.symbolName
//                    )
//                }
//                return nil
//            }
//        } catch {
//            print("시간별 날씨 가져오기 오류: \(error)")
//            return []
//        }
//    }
//
//    /// 🌟 주간 날씨 가져오기
//    func getWeekWeather(location: CLLocation) async -> [WeekWeather] {
//        do {
//            let weather = try await weatherService.weather(for: location)
//            return weather.dailyForecast.map { d in
//                WeekWeather(
//                    date: getDay(d: d.date),
//                    weak: getWeek(d: d.date),
//                    weatherType: getWeatherType(condition: d.condition),
//                    precipitation: String(format: "%.1f", d.precipitationAmount.value),
//                    highTemp: Int(d.highTemperature.value),
//                    lowTemp: Int(d.lowTemperature.value)
//                )
//            }
//        } catch {
//            print("주간 날씨 가져오기 오류: \(error)")
//            return []
//        }
//    }
//
//    /// 🌟 날씨 타입 변환
//    private func getWeatherType(condition: WeatherCondition) -> WeatherType {
//        switch condition {
//        case .drizzle, .heavyRain, .rain, .isolatedThunderstorms, .sunShowers, .scatteredThunderstorms, .thunderstorms:
//            return .rain
//        case .flurries, .snow, .sleet, .sunFlurries, .wintryMix, .blizzard, .heavySnow:
//            return .snow
//        case .mostlyCloudy, .partlyCloudy, .cloudy:
//            return .cloud
//        default:
//            return .sunny
//        }
//    }
//
//    /// 🌟 날짜 변환
//    private func getDay(d: Date) -> Int {
//        return Calendar.current.component(.day, from: d)
//    }
//
//    private func getWeek(d: Date) -> String {
//        let weekdays = ["일", "월", "화", "수", "목", "금", "토"]
//        return weekdays[Calendar.current.component(.weekday, from: d) - 1]
//    }
//}
//
//
////class WeatherManager: NSObject, CLLocationManagerDelegate, ObservableObject {
////    let weatherService = WeatherService()
////    private let locationManager = CLLocationManager()
////    private var currentLocation: CLLocation?
////    
////    override init() {
////        super.init()
////        locationManager.delegate = self
////        locationManager.requestWhenInUseAuthorization()
////        locationManager.startUpdatingLocation()
////    }
////    
////    // MARK: - 현재 날씨 가져오기
////    func getCurrentWeather() async -> currentWeather? {
////        guard let location = currentLocation else {
////            locationManager.startUpdatingLocation()
////            return nil
////        }
////        return await fetchCurrentWeather(for: location)
////    }
////    
////    private func fetchCurrentWeather(for location: CLLocation) async -> currentWeather {
////        let weather = try! await weatherService.weather(for: location)
////        
////        let temp = Int(weather.currentWeather.temperature.value)
////        let humidity = Int(weather.currentWeather.humidity * 100)
////        let precipitation = String(format: "%.1f", weather.currentWeather.precipitationIntensity.value)
////        let isDaylight = weather.currentWeather.isDaylight
////        let symbolName = weather.currentWeather.symbolName
////        
////        let weatherType = determineWeatherType(condition: weather.currentWeather.condition)
////        
////        return currentWeather(
////            temperature: temp,
////            humnidity: humidity,
////            precipitation: precipitation,
////            isDaylight: isDaylight,
////            symbolName: symbolName,
////            weatherType: weatherType
////        )
////    }
////    
////    // MARK: - 오늘의 시간별 날씨 가져오기
////    func getTodayWeather() async -> [HourWeather]? {
////        guard let location = currentLocation else {
////            locationManager.startUpdatingLocation()
////            return nil
////        }
////        return await fetchTodayWeather(for: location)
////    }
////    
////    private func fetchTodayWeather(for location: CLLocation) async -> [HourWeather] {
////        let formatter = DateFormatter()
////        formatter.locale = Locale(identifier: "ko_KR")
////        formatter.dateFormat = "a h"  // 오전/오후 h시
////        
////        let weather = try! await weatherService.weather(for: location)
////        let now = Date()
////        
////        return weather.hourlyForecast
////            .filter { now <= $0.date && $0.date <= now.addingTimeInterval(3600 * 24) }
////            .map { h in
////                let weatherType = determineWeatherType(condition: h.condition)
////                let precipitation = weatherType == .snow
////                    ? String(format: "%.1f", h.snowfallAmount.value)
////                    : String(format: "%.1f", h.precipitationAmount.value)
////                
////                return HourWeather(
////                    time: formatter.string(from: h.date),
////                    weatherType: weatherType,
////                    precipitation: precipitation,
////                    temperature: Int(h.temperature.value),
////                    isDaylight: h.isDaylight,
////                    symbolName: h.symbolName
////                )
////            }
////    }
////    
////    // MARK: - 주간 날씨 가져오기
////    func getWeekWeather() async -> [WeekWeather]? {
////        guard let location = currentLocation else {
////            locationManager.startUpdatingLocation()
////            return nil
////        }
////        return await fetchWeekWeather(for: location)
////    }
////    
////    private func fetchWeekWeather(for location: CLLocation) async -> [WeekWeather] {
////        let weather = try! await weatherService.weather(for: location)
////        
////        return weather.dailyForecast.map { d in
////            let weatherType = determineWeatherType(condition: d.condition)
////            let precipitation = weatherType == .snow
////                ? String(format: "%.1f", d.snowfallAmount.value)
////                : String(format: "%.1f", d.precipitationAmount.value)
////            
////            return WeekWeather(
////                date: getDay(d: d.date),
////                weak: getWeek(d: d.date),
////                weatherType: weatherType,
////                precipitation: precipitation,
////                highTemp: Int(d.highTemperature.value),
////                lowTemp: Int(d.lowTemperature.value)
////            )
////        }
////    }
////    
////    // MARK: - 날씨 타입 결정 함수
////    private func determineWeatherType(condition: WeatherCondition) -> WeatherType {
////        switch condition {
////        case .drizzle, .heavyRain, .rain, .isolatedThunderstorms, .sunShowers, .scatteredThunderstorms, .thunderstorms:
////            return .rain
////        case .flurries, .snow, .sleet, .sunFlurries, .wintryMix, .blizzard, .heavySnow:
////            return .snow
////        case .mostlyCloudy, .partlyCloudy, .cloudy:
////            return .cloud
////        default:
////            return .sunny
////        }
////    }
////    
////    // MARK: - 날짜 변환 함수
////    private func getDay(d: Date) -> Int {
////        return Calendar.current.component(.day, from: d)
////    }
////    
////    private func getWeek(d: Date) -> String {
////        let weekday = Calendar.current.component(.weekday, from: d)
////        let weekDays = ["일", "월", "화", "수", "목", "금", "토"]
////        return weekDays[weekday - 1]
////    }
////    
////    // MARK: - 위치 업데이트 (CLLocationManagerDelegate)
////    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
////        if let location = locations.last {
////            currentLocation = location
////            locationManager.stopUpdatingLocation()
////        }
////    }
////    
////    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
////        print("위치 업데이트 실패: \(error.localizedDescription)")
////    }
////}
