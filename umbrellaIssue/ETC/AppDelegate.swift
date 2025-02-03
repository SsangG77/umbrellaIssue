import UIKit
import BackgroundTasks
import CoreLocation
import SharedWeatherKit  // WeatherManager와 LocationManager 사용

class AppDelegate: UIResponder, UIApplicationDelegate {
    let weatherManager = WeatherManager()
    let locationManager = LocationManager()
    let defaults = UserDefaults(suiteName: "group.com.sangjin.umbrellaWidget")

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // ✅ Background Task 등록
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.sangjin.umbrellaIssue.weatherFetch", using: nil) { task in
            self.handleBackgroundTask(task: task as! BGAppRefreshTask)
        }

        // ✅ 첫 실행 시 백그라운드 작업 예약
        scheduleBackgroundTask()

        return true
    }
    
    // ✅ 15분마다 백그라운드 작업 예약
    func scheduleBackgroundTask() {
        let request = BGAppRefreshTaskRequest(identifier: "com.sangjin.umbrellaIssue.weatherFetch")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60) // 15분 후 실행
        
        do {
            try BGTaskScheduler.shared.submit(request)
            print("✅ 백그라운드 작업 예약됨")
        } catch {
            print("❌ 백그라운드 작업 예약 실패: \(error.localizedDescription)")
        }
    }
    
    // ✅ 백그라운드 작업 처리 (현재 날씨 가져오기)
    func handleBackgroundTask(task: BGTask) {
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }

        print("🔥 백그라운드 동작중 - 날씨 업데이트 시도")

        // 위치 권한 확인 및 요청
        if let location = locationManager.location {
            Task {
                await fetchWeather(location: location)
                task.setTaskCompleted(success: true)
                scheduleBackgroundTask()  // 다음 작업 예약
            }
        } else {
            locationManager.requestLocation()  // 위치 요청
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) { // 위치 업데이트 대기
                if let newLocation = self.locationManager.location {
                    Task {
                        await self.fetchWeather(location: newLocation)
                        task.setTaskCompleted(success: true)
                        self.scheduleBackgroundTask()
                    }
                } else {
                    print("❌ 위치 정보를 가져올 수 없음")
                    task.setTaskCompleted(success: false)
                    self.scheduleBackgroundTask()
                }
            }
        }
    }
    
    // ✅ 날씨 데이터 가져오기
    func fetchWeather(location: CLLocation) async {
        
        if let weatherType = await weatherManager.needUmbrella(location: location) {
            print("지금부터 8시간동안 날씨 타입: \(weatherType.rawValue)")
            
            guard let defaults = UserDefaults(suiteName: "group.com.sangjin.umbrellaWidget") else {
                print("❌ App Group 설정 오류")
                return
            }
            
            defaults.set(weatherType.rawValue, forKey: "CurrentWeatherType")
            defaults.synchronize()
            
            if let saveData = defaults.string(forKey: "CurrentWeatherType") {
                print("📦 저장된 데이터(앱): \(saveData)")
            } else {
                print("❌ 데이터 없음 (앱)")
            }
            
        } else {
            print("❌ 날씨 정보 가져오기 실패")
        }
        
        
//        if let weather = await weatherManager.getCurrentWeather(location: location) {
//            print("🌦️ 현재 날씨 타입: \(weather.weatherType.rawValue)")
//            
//            guard let defaults = UserDefaults(suiteName: "group.com.sangjin.umbrellaWidget") else {
//                       print("❌ App Group 설정 오류")
//                       return
//                }
//            defaults.set(weather.weatherType.rawValue, forKey: "CurrentWeatherType")
//            defaults.synchronize()  // 데이터 즉시 저장
//            
//            if let savedData = defaults.string(forKey: "CurrentWeatherType") {
//                        print("📦 저장된 데이터(앱): \(savedData)")
//            } else {
//                print("❌ 데이터 없음 (앱)")
//            }
//            
//        } else {
//            print("❌ 날씨 정보 가져오기 실패")
//        }
    }
}
