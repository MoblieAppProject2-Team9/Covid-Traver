//
//  ContentView.swift
//  Covid-Traver
//
//  Created by 임승우 on 2023/05/14.
// Upgrade By Jeon 2023.06.18

import SwiftUI

var tossting : String = ""
var tossName : String = ""

struct Home: View {
    let Screen_Size = UIScreen.main.bounds //스크린 사이즈 변수
    var country_name:String = "" //여행지 설정
    //nil이면 지금 hot여행지는? 출력.
    var user_name : String = ""        //읻단 어드민 지정
    var user_id : String = ""
    var find_correct_destination : String = ""      //여행지 찾기
    @StateObject private var destinationsManager = DestinationsManager()
    var aaaa : String = ""      //임시 저장서
    var arriveDate : Date = Date()
    var DepartDate : Date = Date()
    var dateToStringA : String = ""
    var dateToStringD : String = ""
    let dateFormatter = DateFormatter()
    var isExist : Bool = false
    
    
    init( _ id : String, _ name : String) {
        //self.country_name = country
        // destinations에서 유저 아이디(id)랑 같은놈 찾아오기(가장 최근꺼)
        //
        self.user_id = id
        self.user_name = name
        for destination in destinationsManager.destinations{
            if(destination.name == user_id) {
                tossting = destination.name
                self.country_name = destination.arrival
                arriveDate = destination.arrivalDate
                DepartDate = destination.departureDate
                tossName = name
                self.isExist = true
                
                print("name : \(self.user_name)")
                print("id : \(self.user_id)")
                print("country :\(self.country_name) ")
            }
            else{
                
            }
        }
        dateFormatter.dateFormat = "yyyy.MM.dd"
        //self.country_name = aaaa
        self.dateToStringA = dateFormatter.string(from: arriveDate)
        self.dateToStringD = dateFormatter.string(from: DepartDate)
    }
    
    @ObservedObject private var locationManager  = LocationManager()
    var body: some View {
            VStack(alignment: .center) {
//                Button(action : {
//                    renewCountry()
//                }){Text("Renew")}
                Profile(user_name+" 님",Country: self.country_name,Start: self.dateToStringA,End:self.dateToStringD,
                        latitude: locationManager.latitude, longitude: locationManager.longitude
                )//프로필
                    .position(x:Screen_Size.width/2-18, y : 70)
                
                if self.country_name == nil //지금 hot 여행지는?출력
                {
                    VStack(alignment: .leading){
                       
                        Text("지금 HOT 여행지는?")
                            .font(.system(size:20, weight: .bold))
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
                    VStack(alignment: .leading)
                    {
                        Text("당신의 여행은 현재")
                            .font(.system(size:23, weight: .bold))
                            .bold()
                            .foregroundColor(Color.black)
                        Map_kit(width: 360 ,height: 190, nil)
                            .cornerRadius(20)
                            .shadow(radius:3, y:3)
                            .offset(y: -10)
                    }.offset(y:-30)
                }
                //버튼들
                VStack(alignment: .leading){
                    Text("어떤것을 찾으시나요?")
                        .font(.system(size:23, weight: .bold))
                        .bold()
                        .foregroundColor(Color.black)
                    HStack{
                        Buttons(0,width:180, height:120,user_id, user_name) //여행지설정
                        Buttons(1,width:180, height:120,user_id, user_name) //병원찾기
                    }
                    HStack{
                        Buttons(2,width:180, height:120,user_id, user_name) // 가이드라인
                        Buttons(3,width:180, height:120,user_id, user_name) // 번역
                    }
                }.offset(y:-20)
                
                
                
            }
            .navigationBarBackButtonHidden(true)
            .padding()
        }
    
 mutating func renewCountry()
    {
        for list in destinationsManager.destinations{
            if(user_id == list.name)
            {
                tossting = list.name
                aaaa = list.arrival
                arriveDate = list.arrivalDate
                DepartDate = list.departureDate

            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home(tossting,tossName)
    }
}
