//
//  DustView.swift
//  umbrellaIssue
//
//  Created by 차상진 on 1/29/25.
//

import SwiftUI

struct DustView: View {
    var body: some View {
        
        GeometryReader { geo in
            
            ZStack {
                
                Image("dust5")
                    .resizable()
                
                VStack {
                    Text("대기질")
                        .font(.system(size: 20, weight: .bold))
                        .padding(.bottom, 15)
                    
                    Text("61")
                        .font(.system(size: 30, weight: .bold))
                }
                .frame(width: geo.size.width, height: 170)
                .background(Color(hexString: "D9D9D9", opacity: 0.3))
                
            }
//            .padding()
            .frame(width: geo.size.width)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color(hexString: "0038BB"), lineWidth: 3)
            )
        }//geo
        .frame(height: 170)
        .padding()
        
    }
}

#Preview {
    DustView()
}
