//
//  WeakWeatherView.swift
//  umbrellaIssue
//
//  Created by 차상진 on 1/29/25.
//

import SwiftUI
// 메인 앱과 위젯 둘 다에서
import SharedWeatherKit

struct WeakWeatherView: View {
    
    @StateObject private var locationManager = LocationManager()
    let weatherManager = WeatherManager()
    
    
    @Binding var currentWeather: currentWeather
    @State var weekWeathers:[WeekWeather] = []
    
    var body: some View {
        GeometryReader { geo in
            VStack {
//                ScrollView {
                VStack(spacing: 10) {
                        
                        //for문
                    if weekWeathers.isEmpty {
                        VStack {
                            Text("날씨 정보 불러오는 중...")
                                .bold()
                                
                        }
                        .frame(height: 170)
                    } else {
                        
                        ForEach($weekWeathers) { w in
                            
                            SingleWeakWeatherView(w: w)
                            
                            Rectangle()
                                .frame(width: geo.size.width * 0.9, height: 1)
                                .foregroundColor(Color(hexString:
                                    currentWeather.weatherType == .rain ?
                                   currentWeather.isDaylight ? "0038BB" : "7087BD"
                                   :
                                    currentWeather.weatherType == .snow ?
                                   currentWeather.isDaylight ? "2E435C" : "98BCE8"
                                   :
                                    currentWeather.isDaylight ? "5D0000" : "BD7070"
                                   ,
                                   opacity: 0.3)
                                )
                        }
                        
                        
                    }
                    
                       
                       
                    }//vstack
                    .padding()
//                }scrollview
            }
            .padding(.vertical)
            
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
                        locationManager.requestLocation()
                    }
                    .onChange(of: locationManager.location) { newLocation in
                        guard let location = newLocation else { return }
                        Task {
                            weekWeathers = await weatherManager.getWeekWeather(location: location)
                        }
                    }
//            .onAppear {
//                Task {
//                    if let week = await weatherManager.getWeekWeather() {
//                        weekWeathers = week
//                    }
//                }
//            }
        }
        .padding(.horizontal)
        .frame(height: 100 * CGFloat(weekWeathers.count) + 40)
    }
}

struct SingleWeakWeatherView: View {
    
    
    @Binding var w : WeekWeather
    
    
    var body: some View {
        
        let imageSize:CGFloat = 60
        
        HStack(alignment: .center) {
            VStack {
                Text("\(w.date)일")
                    .foregroundColor(w.weak == "토" ? Color(hexString: "5572C9") : w.weak == "일" ? Color(hexString: "DD6565") : .white)
                    .font(.system(size: 17, weight: .semibold))
                
                Text("\(w.weak)")
                    .foregroundColor(w.weak == "토" ? Color(hexString: "5572C9") : w.weak == "일" ? Color(hexString: "DD6565") : .white)
                    .font(.system(size: 30, weight: .bold))
            }
            .padding(.trailing, 10)
            
           
            if w.weatherType == .rain {
                Image("umbrella")
                .resizable()
                .frame(width: imageSize, height: imageSize)
                .padding(.bottom, 5)
            } else if w.weatherType == .cloud {
                Image("cloud")
                .resizable()
                .frame(width: imageSize, height: imageSize)
                .padding(.bottom, 5)
            } else if w.weatherType == .snow {
                Image("snow")
                .resizable()
                .frame(width: imageSize, height: imageSize)
                .padding(.bottom, 5)
            } else {
                Image("sun")
                .resizable()
                .frame(width: imageSize, height: imageSize)
                .padding(.bottom, 5)
            }
            
            if w.precipitation != "0.0" {
                
                Text("\(w.precipitation)mm")
                    .foregroundColor(Color(hexString:
                                            w.weatherType == .rain ?
                                           "5572C9"
                                           :
                                            w.weatherType == .snow ?
                                           "2E435C"
                                           :
                                            "5D0000"
                                          ))
                    .font(.system(size: 16))
            }
            
            Spacer()
            
            HStack {
                Text("\(w.highTemp)℃")
                    .foregroundColor(Color(hexString: "C25A5A"))
                    .font(.system(size: 20, weight: .bold))
                
                Spacer()
                
                Text("\(w.lowTemp)℃")
                    .foregroundColor(Color(hexString: "155CC7"))
                    .font(.system(size: 20, weight: .bold))
            }
            .frame(width: 100)
                
        }
        .padding(.horizontal)
        .frame(height: 67)
    }
}

//#Preview {
//    WeakWeatherView()
//        .background(Color(hexString: "6283F1", opacity: 0.3))
//}
