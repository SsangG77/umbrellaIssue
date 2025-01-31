//
//  WeakWeatherView.swift
//  umbrellaIssue
//
//  Created by 차상진 on 1/29/25.
//

import SwiftUI

struct WeakWeatherView: View {
    
    let weatherManager = WeatherManager()
    @Binding var currentWeather: currentWeather
    
    
    var body: some View {
        GeometryReader { geo in
            VStack {
//                ScrollView {
                VStack(spacing: 10) {
                        
                        //for문
                        SingleWeakWeatherView()
                        
                        Rectangle()
                            .frame(width: geo.size.width * 0.9, height: 1)
                            .foregroundColor(Color(hexString: "0038BB", opacity: 0.3))
                        
                        SingleWeakWeatherView()
                        
                        Rectangle()
                            .frame(width: geo.size.width * 0.9, height: 1)
                            .foregroundColor(Color(hexString: "0038BB", opacity: 0.3))
                        
                        SingleWeakWeatherView()
                        
                        Rectangle()
                            .frame(width: geo.size.width * 0.9, height: 1)
                            .foregroundColor(Color(hexString: "0038BB", opacity: 0.3))
                        
                        SingleWeakWeatherView()
                        
                        Rectangle()
                            .frame(width: geo.size.width * 0.9, height: 1)
                            .foregroundColor(Color(hexString: "0038BB", opacity: 0.3))
                        
                        SingleWeakWeatherView()
                        
                        Rectangle()
                            .frame(width: geo.size.width * 0.9, height: 1)
                            .foregroundColor(Color(hexString: "0038BB", opacity: 0.3))
                       
                    }//vstack
                    .padding()
//                }scrollview
            }
            .background(Color(hexString: "D9D9D9", opacity: 0.2))
            .cornerRadius(20)
            .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            Color(hexString:
                                currentWeather.weatherType == .rain ?
                                  currentWeather.isDaylight ? "0038BB" : "7087BD"
                           :
                                currentWeather.weatherType == .snow ?
                                  currentWeather.isDaylight ? "2E435C" : "98BCE8"
                           :
                            currentWeather.isDaylight ? "5D0000" : "BD7070"
                          ), lineWidth: 3)
                )
            .onAppear {
                Task {
                    await weatherManager.getWeakWeather(lat: 35.1379222, lon: 129.05562775)
                }
            }
        }
        .padding(.horizontal)
        .frame(height: 67 * 7)
    }
}

struct SingleWeakWeatherView: View {
    var body: some View {
        
        let imageSize:CGFloat = 60
        
        HStack(alignment: .center) {
            VStack {
                Text("24일")
                    .foregroundColor(.white)
                    .font(.system(size: 17, weight: .semibold))
                
                Text("금")
                    .foregroundColor(.white)
                    .font(.system(size: 35, weight: .bold))
            }
            .padding(.trailing, 10)
            
            Image("umbrella")
                .resizable()
                .frame(width: imageSize, height: imageSize)
            
            Text("20%")
                .foregroundColor(Color(hexString: "0038BB"))
                .font(.system(size: 16))
            
            Spacer()
            
            Text("15℃")
                .foregroundColor(Color(hexString: "C25A5A"))
                .font(.system(size: 20, weight: .bold))
            
            Text("10℃")
                .foregroundColor(Color(hexString: "155CC7"))
                .font(.system(size: 20, weight: .bold))
                
        }
        .padding(.horizontal)
        .frame(height: 67)
    }
}

//#Preview {
//    WeakWeatherView()
//        .background(Color(hexString: "6283F1", opacity: 0.3))
//}
