//
//  currentWeatherView.swift
//  umbrellaIssue
//
//  Created by 차상진 on 1/29/25.
//

import SwiftUI

struct currentWeatherView: View {
    
    let weatherManager = WeatherManager()
    
    @State var currentWeather: currentWeather? = nil
    
    var body: some View {
        GeometryReader { geo in
            
            let imageSize = geo.size.width * 0.25
            
            
//            if let currentWeather = currentWeather {
//                Text("\(currentWeather.temperature)")
//                Text("\(currentWeather.condition)")
//                Text("\(currentWeather.humnidity)")
//                Text("\(currentWeather.precipitation)")
//
//            } else {
//                Text("날씨 정보 불러오는 중...")
//            }
            
            VStack(alignment: .center) {
                HStack {
                    Image("umbrella")
                        .resizable()
                        .frame(width: imageSize, height: imageSize)
                        .padding(.trailing, 25)
                        
                    VStack {
                        Text("부산광역시")
                            .foregroundColor(Color(hexString: "0038BB"))
                            .fontWeight(.semibold)
                        
                        Text("12℃")
                            .foregroundColor(Color(hexString: "0038BB"))
                            .font(.system(size: 50))
                            .bold()
                    }//VStack - 위치명 / 온도
                }//HStack - 이미지 / 위치명, 온도
                .padding(.bottom, 20)
                
                HStack {
                    Spacer()
                    
                    Text("강수량 : 3mm")
                        .font(.system(size: 13))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("습도 : 13%")
                        .font(.system(size: 13))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("대기질 : 61")
                        .font(.system(size: 13))
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .frame(width: geo.size.width)
                
            }
            .padding()
            .frame(width: geo.size.width)
            .background(Color(hexString: "D9D9D9", opacity: 0.2))
            .cornerRadius(20)
        }
        .frame(height: 170)
        .padding(.horizontal)
        //        .onAppear {
        //            Task {
        //                currentWeather = await weatherManager.getCurrentWeather(lat: 35.1379, lon: 129.0556)
        //            }
        //        }
        
        
    }
}

//#Preview {
//    currentWeatherView()
//        .background(Color(hexString: "6283F1"))
//}
