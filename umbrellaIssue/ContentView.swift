//
//  ContentView.swift
//  umbrellaIssue
//
//  Created by 차상진 on 1/28/25.
//

import SwiftUI
import SwiftData



struct ContentView: View {
    
    
    
    
    
    var body: some View {
        ScrollView {
            currentWeatherView()

            TodayWeatherView()
            
            WeakWeatherView()
            
            DustView()

            
        }
        .frame(maxHeight: .infinity)
        .contentMargins([.top, .bottom], 80)
        .background(Gradient(colors: [Color(hexString: "6283F1"), Color(hexString: "D7D7D7")]))
        .ignoresSafeArea()
        

    }

   
}

#Preview {
    ContentView()
}
