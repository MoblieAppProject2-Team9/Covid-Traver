//
//  destination.swift
//  Covid-Traver
//
//  Created by jeon on 2023/06/18.
//

import Foundation

struct destination: Identifiable,Encodable,Decodable{
    let id = UUID()
    let name: String        //여기 유저 아이디가 대체될 예정
    let departureDate: Date
    let arrivalDate: Date
    let departure: String
    let arrival: String
}
