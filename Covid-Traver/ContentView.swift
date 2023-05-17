//
//  ContentView.swift
//  Covid-Traver
//
//  Created by 임승우 on 2023/05/14.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Profile("홍길동님",Country: nil)//프로필
            MapView(width: 300, height:200) //map kit
            HStack{
                Photo_recommend("Eiffel", width:100, height:150) //여행지 추천사진
                Photo_recommend("Bigben", width:100, height:150) //여행지 추천사진
                
            }
            
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
