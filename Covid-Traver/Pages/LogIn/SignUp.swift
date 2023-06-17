//
//  SignUp.swift
//  Covid-Traver
//
//  Created by 임광환 on 2023/05/18.
//

import SwiftUI

struct SignUp: View {
    @State private var name: String = ""
    @State private var id: String = ""
    @State private var password: String = ""
    @State private var birthDate: Date = Date()
    @State private var isVaccinated: Bool = false
    
    var body: some View {
        VStack {
            Text("회원가입")
                .font(.largeTitle)
                .padding(.bottom, 30)
            
            HStack{
                Image(systemName: "person.fill")
                    .scaledToFill()
                    .frame(width: 35,height: 35)
                
                TextField("Name", text: $name)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.bottom, 10)
            }
            
            HStack {
                Image(systemName: "calendar")
                    .scaledToFill()
                    .frame(width: 35,height: 35)
                
                DatePicker("생년월일", selection: $birthDate, displayedComponents: .date)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.bottom, 10)
            }
            
            HStack {
                Image(systemName: "person")
                    .scaledToFill()
                    .frame(width: 35,height: 35)
                
                TextField("ID", text: $id)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.bottom, 10)
            }
            
            HStack {
                Image(systemName: "lock")
                    .scaledToFill()
                    .frame(width: 35,height: 35)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.bottom, 10)
            }
            
            HStack {
                Text("코로나19백신 접종 여부 (최근 6개월 이내)")
                    .padding(.leading, 5)
                    .foregroundColor(.black)
                    .onTapGesture {
                        isVaccinated.toggle()
                    }
                Button(action: {
                    isVaccinated = !isVaccinated
                }) {
                    Image(systemName: isVaccinated ? "checkmark.square" : "square")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(isVaccinated ? .blue : .gray)
                }
            }
            .padding(.bottom, 10)
            
            
            Button(action: {
                // 회원정보 DB에 저장
                // 로그인 창으로 넘어가기
                print("이름      : \(name)")
                print("생년월일   : \(birthDate)")
                print("ID       : \(id)")
                print("Password : \(password)")
                print("백신여부   : \(isVaccinated)")
            }) {
                Text("시작하기")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            Spacer()
        }
        .padding()
    }
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp()
    }
}
