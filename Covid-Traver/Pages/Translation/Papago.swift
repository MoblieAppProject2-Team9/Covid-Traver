//
//  Papago.swift
//  Covid-Traver
//
//  Created by 임광환 on 2023/05/17.
//

import SwiftUI
import Alamofire
import SwiftyJSON
import AVFoundation


struct Papago: View {
    @State var sourceLanguage = "ko"
    @State var targetLanguage = "en"
    @State private var sourceText = ""
    @State private var targetText = ""
    
    var body: some View {
        VStack {
            HStack{
                Image("translate")
                    .resizable()
                    .frame(width: 50,height: 50)
                
                Text("번역")
                    .padding()
            }
            .padding([.bottom,.top], 30)
            
            // "Enter text to translate"
            // TextField는 한줄로만 입력 가능
            TextEditor(text: $sourceText)
                .padding(10)
                .frame(height: 200, alignment: .topLeading)
                .scrollContentBackground(.hidden)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .shadow(color: Color.primary.opacity(0.33), radius: 1, x: 2, y: 2)
                .lineSpacing(10)
                .padding()
            
            HStack(alignment: .center) {
                Spacer()
                
                // source 언어 선택 (기본 "ko")
                Picker("Source Language", selection: $sourceLanguage) {
                    ForEach(languages) { language in
                        Text(language.name).tag(language.code)
                    }
                }
                .pickerStyle(.automatic)
                
                Spacer()
                
                Image(systemName: "arrow.left.arrow.right")
                    .font(Font.title.weight(.light))
                
                Spacer()

                // target 언어 선택 (기본 "en")
                Picker("Target Language", selection: $targetLanguage) {
                    ForEach(languages) { language in
                        Text(language.name).tag(language.code)
                    }
                }
                .pickerStyle(.automatic)
                
                Spacer()
            }
            
            VStack {
                // "Translated text"
                TextField("Translated text",text: $targetText)
                    .padding(10)
                    .frame(height: 200, alignment: .topLeading)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .shadow(color: Color.primary.opacity(0.33), radius: 1, x: 2, y: 2)
                    .lineSpacing(10)
                    .padding()
                
                Button(action: {
                    TTSManager.shared.play(string: targetText, language: targetLanguage)
                }) {
                    Image(systemName: "speaker.wave.2")
                        .padding(10)
                        .imageScale(.large)
                        .frame(width: 370,alignment: .topLeading)
                }
            }
            
            
            Button(action: {
                translate(text: self.sourceText, source: self.sourceLanguage, target: self.targetLanguage) { translatedText in
                    targetText = translatedText ?? "다시 입력해주세요"
                }
            }){
                Text("번역")
                    .frame(width: 300)
            }
            .foregroundColor(.white)
            .padding()
            .background(RoundedRectangle(cornerRadius: 20).fill(Color.blue))
            
        }
        .frame(height: 700)
    }
    
    // 번역 기능
    func translate(text: String, source: String, target: String, completionHandler: @escaping (String?) -> Void) {
        let url = "https://openapi.naver.com/v1/papago/n2mt"
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
            "X-Naver-Client-Id": "oEn6h9cGyt6BRv1z6XCF",
            "X-Naver-Client-Secret": "1Oical3qld"
        ]
        let parameters: Parameters = [
            "source": source,
            "target": target,
            "text": text
        ]
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let translatedText = json["message"]["result"]["translatedText"].string
                completionHandler(translatedText)
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler(nil)
            }
        }
    }
}

struct Papago_Previews: PreviewProvider {
    static var previews: some View {
        Papago()
    }
}
