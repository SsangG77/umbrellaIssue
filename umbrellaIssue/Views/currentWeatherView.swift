//
//  currentWeatherView.swift
//  umbrellaIssue
//
//  Created by 차상진 on 1/29/25.
//

import SwiftUI
// 메인 앱과 위젯 둘 다에서
import SharedWeatherKit

struct currentWeatherView: View {
    
    
    
    @Binding var currentWeather: currentWeather
    @Binding var locationName: String
    
    var body: some View {
        GeometryReader { geo in
            
            let imageSize = geo.size.width * 0.25
            
            
//            if let currentWeather = currentWeather {
                VStack(alignment: .center) {
                    HStack {
                        Image(
                            currentWeather.weatherType == .rain ? "umbrella" :
                                currentWeather.weatherType == .cloud ? "cloud" :
                                currentWeather.weatherType == .snow ? "snowman" :
                                currentWeather.isDaylight ?"sun" : "moon"
                        )
                            .resizable()
                            .frame(width: imageSize, height: imageSize)
                            .padding(.trailing, 25)
                            
                        VStack {
                            Text(locationName)
                                .foregroundColor(Color(hexString: 
                                                        currentWeather.weatherType == .rain ? 
                                                       "0038BB"
                                                       :
                                                        currentWeather.weatherType == .snow ?
                                                       currentWeather.isDaylight ? "2E435C" : "98BCE8"
                                                       :
                                                        "5D0000"
                                                      ))
                                .fontWeight(.semibold)
                            
                            Text(String(currentWeather.temperature) + "℃")
                                .foregroundColor(Color(hexString:
                                                        currentWeather.weatherType == .rain ?
                                                       "0038BB"
                                                       :
                                                        currentWeather.weatherType == .snow ?
                                                       currentWeather.isDaylight ? "2E435C" : "98BCE8"
                                                       :
                                                        "5D0000"
                                                      ))
                                .font(.system(size: 50))
                                .bold()
                        }//VStack - 위치명 / 온도
                    }//HStack - 이미지 / 위치명, 온도
                    .padding(.bottom, 20)
                    
                    HStack {
                        Spacer()
                        
                        Text("강수량 : \(currentWeather.precipitation)mm")
                            .font(.system(size: 13))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text("습도 : \(currentWeather.humnidity)%")
                            .font(.system(size: 13))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
//                        Text("대기질 : 61")
//                            .font(.system(size: 13))
//                            .foregroundColor(.white)
//                        
//                        Spacer()
                    }
                    .frame(width: geo.size.width)
                    
                }
                .padding()
                .frame(width: geo.size.width)
                .background(Color(hexString: "D9D9D9", opacity: 0.2))
                .cornerRadius(20)
                
                

//            } else {
//                VStack(alignment: .center) {
//                    Text("날씨 정보 불러오는 중...")
//                        .bold()
//                }
//                .frame(width: geo.size.width, height: geo.size.height)
//            }
            
            
        }
        .frame(height: 170)
        .padding(.horizontal)
        
        
        
    }
}

//#Preview {
//    currentWeatherView()
//        .background(Color(hexString: "6283F1"))
//}
