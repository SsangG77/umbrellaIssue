//
//  ContentView.swift
//  umbrellaIssue
//
//  Created by 차상진 on 1/28/25.
//

import SwiftUI
import SwiftData



struct ContentView: View {
    
    let weatherManager = WeatherManager()
    
    @State var currentWeather: currentWeather? = nil
    
    var body: some View {
        ScrollView {
            if let currentWeather = currentWeather {
                currentWeatherView(currentWeather: Binding(get: { currentWeather }, set: { self.currentWeather = $0 }))
            } else {
                ProgressView() // 데이터 로딩 중 표시
            }
            
            if let currentWeather = currentWeather {
                TodayWeatherView(currentWeather: Binding(get: { currentWeather }, set: { self.currentWeather = $0 }))
            } else {
                ProgressView()
            }
            if let currentWeather = currentWeather {
                WeakWeatherView(currentWeather: Binding(get: { currentWeather }, set: { self.currentWeather = $0 }))
            } else {
                ProgressView()
            }
            
           
            
            DustView()

            
        }
        .frame(maxHeight: .infinity)
        .contentMargins([.top, .bottom], 80)
        .background(Gradient(colors: [
            Color(hexString: currentWeather?.weatherType == .rain
                  ?
                  "6283F1"
                  :
                    currentWeather?.weatherType == .snow
                  ?
                  "446389"
                  :
                  "F16262"
                 ),
            Color(hexString:
                    ((currentWeather?.isDaylight) != nil) ?
                    currentWeather?.weatherType == .rain
                  ?
                  "01003A"
                  :
                    currentWeather?.weatherType == .snow || currentWeather?.weatherType == .sunny ? "000000" : "000000"
                  :
                  "D7D7D7"
                  
                 )
        ]))
        .ignoresSafeArea()
        .onAppear {
            Task {
                currentWeather = await weatherManager.getCurrentWeather(lat: 35.1379, lon: 129.0556)
            }
        }
    }
}

#Preview {
    ContentView()
}
