//
//  ContentView.swift
//  Covid-Traver
//
//  Created by 임승우 on 2023/05/14.
//

import SwiftUI

struct Home: View {
    let Screen_Size = UIScreen.main.bounds //스크린 사이즈 변수
    var country_name:String? //여행지 설정
    //nil이면 지금 hot여행지는? 출력.
    init(_ country: String?)
    {
        self.country_name = country
    }
    var body: some View {
        NavigationView{
            VStack(alignment: .center) {
                Profile("홍길동님",Country: self.country_name,Start: "",End:"")//프로필
                    .position(x:Screen_Size.width/2-18, y : 70)
                
                if self.country_name == nil //지금 hot 여행지는?출력
                {
                    VStack(alignment: .leading){
                       
                        Text("지금 HOT 여행지는?")
                            .font(.system(size:23, weight: .bold))
                            .bold()
                            .foregroundColor(Color.black)
                        ScrollView(.horizontal, showsIndicators: false)
                        {
                            HStack{
                                Photo_recommend("modives", width: Screen_Size.width/4+15, height: 180)
                                Photo_recommend("Bigben", width: Screen_Size.width/4+15, height: 180)
                                Photo_recommend("Eiffel", width: Screen_Size.width/4+15, height: 180)
                                Photo_recommend("japan_street", width: Screen_Size.width/4+15, height: 180)
                                Photo_recommend("timesquare", width: Screen_Size.width/4+15, height: 180)
                                Photo_recommend("Taiwan", width: Screen_Size.width/4+15, height: 180)
                            }.frame(height:190)
                        }.offset(y:-10)
                    }.offset(y:-20)
                }
                else //여행지 설정 완료. 지도출력
                {
                    
                }
                //버튼들
                VStack(alignment: .leading){
                    Text("어떤것을 찾으시나요?")
                        .font(.system(size:23, weight: .bold))
                        .bold()
                        .foregroundColor(Color.black)
                    HStack{
                        Buttons(0,width:180, height:120) //여행지설정
                        Buttons(1,width:180, height:120) //병원찾기
                    }
                    HStack{
                        Buttons(2,width:180, height:120) // 가이드라인
                        Buttons(3,width:180, height:120) // 번역
                    }
                }.offset(y:-20)
              
                
                
            }
            .padding()
        }
        
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home(nil)
    }
}
