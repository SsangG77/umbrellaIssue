//
//  ContentView.swift
//  umbrellaIssue
//
//  Created by 차상진 on 1/28/25.
//

import SwiftUI
import SwiftData
// 메인 앱과 위젯 둘 다에서
import SharedWeatherKit



struct ContentView: View {
    
    let weatherManager = WeatherManager()
    @StateObject private var locationManager = LocationManager()
    
    @State var currentWeather: currentWeather? = nil
    
    var body: some View {
        ScrollView {
            if let currentWeather = currentWeather {
                currentWeatherView(currentWeather: Binding(get: { currentWeather }, set: { self.currentWeather = $0 }), locationName: $locationManager.locality)
            } else {
                ProgressView() // 데이터 로딩 중 표시
                    .frame(width: UIScreen.main.bounds.width, height: 170)
            }
            
            if let currentWeather = currentWeather {
                TodayWeatherView(currentWeather: Binding(get: { currentWeather }, set: { self.currentWeather = $0 }))
            } else {
                ProgressView()
                    .frame(width: UIScreen.main.bounds.width, height: 170)
            }
            if let currentWeather = currentWeather {
                WeakWeatherView(currentWeather: Binding(get: { currentWeather }, set: { self.currentWeather = $0 }))
            } else {
                ProgressView()
                    .frame(width: UIScreen.main.bounds.width, height: 170)
            }
            
           
            
//            DustView()

            
        }
        .frame(maxHeight: .infinity)
        .contentMargins([.top, .bottom], 80)
        .background(Gradient(colors: [
            Color(hexString: currentWeather?.weatherType == .rain
                  ?
                  "6283F1"
                  :
                    currentWeather?.weatherType == .snow || currentWeather?.weatherType == .cloud
                  ?
                  "446389"
                  :
                  "F16262"
                 ),
            Color(hexString: currentWeather?.isDaylight == true ? "D7D7D7"
                  :
                    currentWeather?.weatherType == .rain ? "01003A"
                  :
                    currentWeather?.weatherType == .cloud || currentWeather?.weatherType == .snow ? "000000"
                  :
                    "171212"
                 )
        ]))
        .ignoresSafeArea()
        .onAppear {
            locationManager.requestLocation()
        }
        .onChange(of: locationManager.location) { newLocation in
            guard let location = newLocation else { return }
            Task {
                let newCurrentWeather = await weatherManager.getCurrentWeather(location: location)
                withAnimation {
                    currentWeather = newCurrentWeather
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
