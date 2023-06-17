//
//  Language.swift
//  Covid-Traver
//
//  Created by 임광환 on 2023/05/22.
//

import Foundation

struct Language: Identifiable {
    let id = UUID()
    let name: String
    let code: String
}

let languages = [
    Language(name: "한국어", code: "ko"),
    Language(name: "영어", code: "en"),
    Language(name: "일본어", code: "ja"),
    Language(name: "중국어", code: "zh-CN"),
    Language(name: "베트남어", code: "vi"),
    Language(name: "인도네시아어", code: "id"),
    Language(name: "태국어", code: "th"),
    Language(name: "독일어", code: "de"),
    Language(name: "러시아어", code: "ru"),
    Language(name: "스페인어", code: "es"),
    Language(name: "이탈리아어", code: "it"),
    Language(name: "프랑스어", code: "fr")
]
