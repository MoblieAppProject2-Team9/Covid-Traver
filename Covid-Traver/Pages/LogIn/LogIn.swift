//
//  SignIn.swift
//  Covid-Traver
//
//  Created by 임광환 on 2023/05/18.
//

import SwiftUI

var test111 : String = ""
var givename : String = ""

struct LogIn: View {
    @State private var id: String = ""
    @State private var password: String = ""
    @State private var showAlert = false
    @State private var isLoggedIn = false
    @StateObject private var userManager = UserManager()
    @State private var ShowSignUp = false
    
    var body: some View {
        NavigationView {
            VStack {
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
                
                NavigationLink(destination: FirstView(), isActive: $isLoggedIn) {
                    Button(action: {
                        // 로그인 정보 확인 후 승인 -> 메인화면, 없으면 -> 알림
                        login()
                    }) {
                        Text("로그인")
                            .foregroundColor(Color.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                
                HStack{
                    Text("아직 회원이 아니신가요? ")
                    
                    Button(action: {
                        // 회원가입 화면으로 이동
                        ShowSignUp = true
                    }) {
                        Text("회원 가입")
                            .foregroundColor(.blue.opacity(0.8))
                            .underline(color: .blue)
                    }
                }
                .frame(width: 290, height: 40, alignment: .trailing)
                .sheet(isPresented: $ShowSignUp, content: {
                                    SignUp()
                                })
                
                Spacer()
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(title: Text("로그인 실패"), message: Text("아이디와 비밀번호를 확인해주세요."), dismissButton: .default(Text("확인")))
            }
        }
    }
    
    func verification() -> Bool
    {
        for list in userManager.users{
            if(list.id == id && list.password == password)
            {
                test111 = list.id
                givename = list.name
                return true
            }
        }
        return false
    }
    
    
    private func login() {
        // 로그인 정보 확인 후 승인 여부를 판단하는 로직을 구현합니다.
        // 예시로는 간단한 로그인 체크를 수행하도록 하겠습니다.
        if (verification() == true) {
            // 로그인 성공 시 메인 화면으로 이동
            isLoggedIn = true
        } else {
            // 로그인 실패 시 알림 표시
            showAlert = true
        }
        //isLoggedIn = false
    }
}

struct FirstView: View {
    var body: some View {
        Home(test111,givename)
    }
}

struct LogIn_Previews: PreviewProvider {
    static var previews: some View {
        LogIn()
    }
}
