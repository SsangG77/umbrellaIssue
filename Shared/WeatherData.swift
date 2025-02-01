import Foundation
import CoreLocation

enum WeatherType: String {
    case sunny = "맑음"
    case rain = "비"
    case snow = "눈"
    case cloudy = "흐림"
}

struct currentWeather {
    var temperature: Double
    var weatherType: WeatherType
    var isDaylight: Bool
}

class WeatherManager {
    let defaults = UserDefaults(suiteName: "group.com.sangjin.umbrellaIssue")
    
    func saveWeatherType(weatherType: WeatherType) {
        print("saveWeatherType() = \(weatherType)")
        defaults?.set(weatherType.rawValue, forKey: "weatherType")
    }
    
    func getSavedWeatherType() -> WeatherType {
        let weatherString = defaults?.string(forKey: "weatherType") ?? "맑음"
        return WeatherType(rawValue: weatherString) ?? .sunny
    }
    
    func getCurrentWeather(location: CLLocation) async -> currentWeather? {
        let weather = currentWeather(
            temperature: 20.0,
            weatherType: getSavedWeatherType(),
            isDaylight: true
        )
        saveWeatherType(weatherType: weather.weatherType)
        return weather
    }
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var location: CLLocation?
    @Published var locality: String = ""
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        self.location = location
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let placemark = placemarks?.first {
                self.locality = placemark.locality ?? ""
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
} 