//
//  TodayWeatherView.swift
//  umbrellaIssue
//
//  Created by 차상진 on 1/29/25.
//

import SwiftUI


struct hourWeather: Identifiable, Codable {
    let id = UUID()
    var time = Date()
    var condition: String
    var precipitation: Int
    var temp: Int
    
}


struct TodayWeatherView: View {
    var body: some View {
            HStack {
                ScrollView(.horizontal, showsIndicators: true) {
                    HStack {
                        Rectangle()
                            .frame(width: 1, height: 170)
                            .foregroundColor(Color(hexString: "0038BB", opacity: 0.3))
                        
                        //for문
                        SingleTodayWeatherView()
                        
                        Rectangle()
                            .frame(width: 1, height: 170)
                            .foregroundColor(Color(hexString: "0038BB", opacity: 0.3))
                        
                        SingleTodayWeatherView()
                        
                        Rectangle()
                            .frame(width: 1, height: 170)
                            .foregroundColor(Color(hexString: "0038BB", opacity: 0.3))
                        
                        SingleTodayWeatherView()
                        
                        Rectangle()
                            .frame(width: 1, height: 170)
                            .foregroundColor(Color(hexString: "0038BB", opacity: 0.3))
                        
                        SingleTodayWeatherView()
                        
                        Rectangle()
                            .frame(width: 1, height: 170)
                            .foregroundColor(Color(hexString: "0038BB", opacity: 0.3))
                       
                    }//hstack
                    .padding(.horizontal)
                }//scrollview
            }
            .background(Color(hexString: "D9D9D9", opacity: 0.2))
            .cornerRadius(20)
            .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(hexString: "0038BB"), lineWidth: 3)
                )
            .padding()
            .frame(height: 270)
    }
}




struct SingleTodayWeatherView: View {
    var body: some View {
        
        let imageSize:CGFloat = 50
        
        VStack(alignment: .center ) {
            
            Text("Now")
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.bottom, 10)
            
            Image("umbrella")
                .resizable()
                .frame(width: imageSize, height: imageSize)
                .padding(.bottom, 5)
            
            Text("20%")
                .foregroundColor(Color(hexString: "0038BB"))
                .padding(.bottom, 15)
            
            Text("13℃")
                .foregroundColor(.white)
                .fontWeight(.bold)
            
        }
        .frame(width: 60, height: 170)
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
