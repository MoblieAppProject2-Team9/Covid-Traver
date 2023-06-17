//
//  Find_Hospital.swift
//  Covid-Traver
//
//  Created by 임승우 on 2023/05/19.
//

import SwiftUI

struct Find_Hospital: View {
    @State private var distance:CGFloat? = 200
    var body: some View {
        VStack{
            Map_kit(width:400, height: 880, "Hospital")
        }.edgesIgnoringSafeArea(.top)
    }
}
struct Find_Hospital_Previews: PreviewProvider {
    static var previews: some View {
        Find_Hospital().cornerRadius(14)
    }
}
