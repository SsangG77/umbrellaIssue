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
        VStack {
            
            if let currentWeather = currentWeather {
                Text("\(currentWeather.temperature)")
                Text("\(currentWeather.condition)")
                Text("\(currentWeather.humnidity)")
                Text("\(currentWeather.precipitation)")
                
            } else {
                Text("날씨 정보 불러오는 중...")
            }
            
            
            
        }
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
