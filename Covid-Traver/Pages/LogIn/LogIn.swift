//
//  SignIn.swift
//  Covid-Traver
//
//  Created by 임광환 on 2023/05/18.
//

import SwiftUI

struct LogIn: View {
    @State private var id: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack{
            // 앱 이미지 추가 예정
            Text("USER LOGIN")
                .padding(.top, 200)
            
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
            
            Button(action: {
                // 로그인 정보 확인 후 승인 -> 메인화면, 없으면 -> 알림
                print("ID       : \($id)")
                print("Password : \($password)")
            }) {
                Text("로그인")
                    .foregroundColor(Color.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            HStack{
                Text("아직 회원이 아니신가요? ")
                
                Button(action: {
                    // 회원 가입 창으로 넘어감
                }) {
                    Text("회원 가입")
                        .foregroundColor(.blue.opacity(0.8))
                        .underline(color: .blue)
                }
            }
            .frame(width: 290, height: 40, alignment: .trailing)
            
            Spacer()
        }
        .padding()
    }
}

struct LogIn_Previews: PreviewProvider {
    static var previews: some View {
        LogIn()
    }
}
