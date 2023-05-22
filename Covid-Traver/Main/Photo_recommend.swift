//
//  Photo_recommend.swift
//  Covid-Traver
//
//  Created by 임승우 on 2023/05/16.
//

import SwiftUI

struct Photo_recommend: View {
    private var name:String = "" //사진 이름.
    private var width:CGFloat
    private var height:CGFloat
    init(_ name:String, width:CGFloat , height:CGFloat)
    {
        self.name = name
        self.width = width
        self.height = height
    }
    var body: some View {
        Image("\(self.name)")
            .resizable() // 이미지 크기 조정 가능
            .aspectRatio(contentMode: .fill) // 종횡비 유지 및 채우기
            .frame(width: self.width, height: self.height)
            .clipped() // 프레임 내에서 이미지를 자르기
            .cornerRadius(14)
            .shadow(color:Color.black.opacity(0.5), radius: 1, x:1, y: 3)
    }
}

struct Photo_recommend_Previews: PreviewProvider {
    static var previews: some View {
        Photo_recommend("Bigben", width: 300, height: 200)
    }
}
