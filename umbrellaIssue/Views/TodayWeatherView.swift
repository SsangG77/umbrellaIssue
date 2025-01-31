//
//  TodayWeatherView.swift
//  umbrellaIssue
//
//  Created by 차상진 on 1/29/25.
//

import SwiftUI


//struct hourWeather: Identifiable, Codable {
//    let id = UUID()
//    var time = Date()
//    var condition: String
//    var precipitation: Int
//    var temp: Int
//    
//}


struct TodayWeatherView: View {
    
    let weatherManager = WeatherManager()
    @State var hourWeathers:[HourWeather] = []
    
    @Binding var currentWeather: currentWeather
    
    var body: some View {
            HStack {
                ScrollView(.horizontal, showsIndicators: true) {
                    HStack {
                        
                        
                        if hourWeathers.isEmpty {
                            VStack {
                                Text("날씨 정보 불러오는 중...")
                                    .bold()
                                    
                            }
                            .frame(height: 170)
                        } else {
                            Rectangle()
                                .frame(width: 1, height: 170)
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
                            
                            
                            ForEach($hourWeathers) { h in
                                SingleTodayWeatherView(h: h, weatherType: $currentWeather.weatherType)
                                
                                Rectangle()
                                    .frame(width: 1, height: 170)
                                    .foregroundColor(Color(hexString:
                                        currentWeather.weatherType == .rain ?
                                          currentWeather.isDaylight ? "0038BB" : "7087BD"
                                   :
                                        currentWeather.weatherType == .snow ?
                                          currentWeather.isDaylight ? "2E435C" : "98BCE8"
                                   :
                                    currentWeather.isDaylight ? "5D0000" : "BD7070"
                                     , opacity: 0.3))
                            }
                        }
                        
                       
                    }//hstack
                    .padding(.horizontal)
                }//scrollview
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
                          ),
                                
                                
                                lineWidth: 3)
                )
            .padding()
            .frame(height: 270)
            .onAppear {
                Task {
                    hourWeathers = await weatherManager.getTodayWeather(lat: 35.1379222, lon: 129.05562775)
                }
            }
    }
}




struct SingleTodayWeatherView: View {
    
    @Binding var h:HourWeather
    @Binding var weatherType:WeatherType
    
    var body: some View {
        
        let imageSize:CGFloat = 50
        
        
        
        
        
        VStack(alignment: .center ) {
            
            Text(h.time+"시")
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.bottom, 10)
            
            if h.weatherType == .rain {
                Image("umbrella")
                .resizable()
                .frame(width: imageSize, height: imageSize)
                .padding(.bottom, 5)
            } else if h.weatherType == .cloud {
                Image("cloud")
                .resizable()
                .frame(width: imageSize, height: imageSize)
                .padding(.bottom, 5)
            } else if h.weatherType == .snow {
                Image("snow")
                .resizable()
                .frame(width: imageSize, height: imageSize)
                .padding(.bottom, 5)
            } else {
                if h.isDaylight {
                    Image("sun")
                        .resizable()
                        .frame(width: imageSize, height: imageSize)
                        .padding(.bottom, 5)
                } else {
                    Image("moon")
                    .resizable()
                    .frame(width: imageSize, height: imageSize)
                    .padding(.bottom, 5)
                }
            }
                
                
            
            
            Text(h.precipitation + "mm")
                .foregroundColor(Color(hexString:
                                        weatherType == .rain ?
                                       "0038BB"
                                       :
                                        weatherType == .snow ?
                                       "2E435C"
                                       :
                                        "5D0000"
                                      ))
                .padding(.bottom, 15)
            
            Text("\(String(h.temperature))℃")
                .foregroundColor(.white)
                .fontWeight(.bold)
            
        }
        .frame(width: 70, height: 170)
//        .border(width: 1, edges: [.trailing, .leading], color: Color(hexString: "0038BB", opacity: 0.4))
        .padding()
    }
}



//#Preview {
//    TodayWeatherView()
//        .padding(.top, 100)
//        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
//        .background(Color(hexString: "6283F1", opacity: 0.8))
//}
