//
//  Buttons.swift
//  Covid-Traver
//
//  Created by 임승우 on 2023/05/19.
//

import SwiftUI

struct Buttons: View {
    let index:Int //0: 여행지 설정 / 1: 병원 / 2: 가이드라인 / 3: 번역
    let width:CGFloat
    let height:CGFloat
    init(_ index:Int, width: CGFloat, height: CGFloat)
    {
        self.index = index
        self.width = width
        self.height = height
    }
    var body: some View {
        
        switch index {
        case 0: //여행지설정
            NavigationLink(destination: Set_destination()){
                VStack{
                    HStack{
                        Image("world")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: self.width/5, height: self.width/5)
                            .clipped()
                        Text("여행지설정")
                            .font(.system(size:27,weight:.bold))
                            .bold()
                            .foregroundColor(Color.black)
                    }
                    
                    Text("당신의 여행을\n 알려주세요!")
                        .font(.system(size:20,weight:.bold))
                        .foregroundColor(Color.black.opacity(0.7))
                        .cornerRadius(10)
                }
                .frame(width:self.width , height: self.height)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.5), radius: 1, x: 1, y: 3)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.gray, lineWidth: 1)
                )
            }
            
        case 1://병원찾기
            NavigationLink(destination:Find_Hospital())
            {
                VStack{
                    HStack{
                        Image("hospital-building")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: self.width/5, height: self.width/5)
                            .clipped()
                        Text("병원찾기")
                            .font(.system(size:27,weight:.bold))
                            .bold()
                            .foregroundColor(Color.black)
                    }
                    
                    Text("가까운 병원이\n 필요하신가요?")
                        .font(.system(size:20,weight:.bold))
                        .foregroundColor(Color.black.opacity(0.7))
                        .cornerRadius(10)
                }
                .frame(width:self.width , height: self.height)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.5), radius: 1, x: 1, y: 3)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.gray, lineWidth: 1)
                )
            }
        case 2://가이드라인
            NavigationLink(destination: Guideline())
            {
                VStack{
                    HStack{
                        Image("template")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: self.width/5, height: self.width/5)
                            .clipped()
                        Text("가이드라인")
                            .font(.system(size:27,weight:.bold))
                            .bold()
                            .foregroundColor(Color.black)
                    }
                    
                    Text("여행국가의 코로나19\n 가이드가 필요하신가요?")
                        .font(.system(size:18,weight:.bold))
                        .foregroundColor(Color.black.opacity(0.7))
                        .cornerRadius(10)
                }
                .frame(width:self.width , height: self.height)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.5), radius: 1, x: 1, y: 3)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.gray, lineWidth: 1)
                )
            }
           
        case 3://번역
<<<<<<< HEAD
            NavigationLink(destination: Papago())
=======
            NavigationLink(destination: Translation())
>>>>>>> 756a6f4fd77b9b042dae6d4f882d486c316daa78
            {
                VStack{
                    HStack{
                        Image("translate")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: self.width/5, height: self.width/5)
                            .clipped()
                        Text("번역")
                            .font(.system(size:27,weight:.bold))
                            .bold()
                            .foregroundColor(Color.black)
                    }
                    
                    Text("의사소통에 어려움이\n 있으신가요?")
                        .font(.system(size:20,weight:.bold))
                        .foregroundColor(Color.black.opacity(0.7))
                        .cornerRadius(10)
                }
                .frame(width:self.width , height: self.height)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.5), radius: 1, x: 1, y: 3)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.gray, lineWidth: 1)
                )
            }
<<<<<<< HEAD
        
//        case 4:
//            NavigationLink(destination: Home()) {
//
//            }
=======
            
>>>>>>> 756a6f4fd77b9b042dae6d4f882d486c316daa78
        default:
            //없으면 에러
            Spacer()
        }
    }
}

struct Buttons_Previews: PreviewProvider {
    static var previews: some View {
        Buttons(0,width:180, height:120)
        Buttons(1,width:180, height:120)
        Buttons(2,width:180, height:120)
        Buttons(3,width:180, height:120)
    }
}
