//
//  SignUp.swift
//  Covid-Traver
//
//  Created by 임광환 on 2023/05/18.
//

import SwiftUI

var test2 : String = ""
var giveName : String = ""

struct SignUp: View {
    @State private var name: String = ""
    @State private var id: String = ""
    @State private var password: String = ""
    @State private var birthDate: Date = Date()
    @State private var isVaccinated: Bool = false
    @State private var showAlert : Bool = false
    @StateObject private var userManager = UserManager()
    
    @Environment(\.presentationMode) var presentationMode
    
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
                print("이름      : \(name)")
                print("생년월일   : \(birthDate)")
                print("ID       : \(id)")
                print("Password : \(password)")
                print("백신여부   : \(isVaccinated)")
                print("test : \(userManager.users)")
                
                //안떠올라서 그냥 유효값 다 안넣으면 눌러도 안되게 값 다 넣고 버튼 누르면 작동되게
                if(isvalid() == true){
                    presentationMode.wrappedValue.dismiss()
                }
            })
            {
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
    
    func isvalid() ->Bool           //유효성 검사
    {
        if(name.isEmpty || id.isEmpty || password.isEmpty ){
         
         return false
        }       //공백검사끝
        
        //비밀번호 길이랑 유저아이디 중복검사
        for list in userManager.users{
            if(id != list.id)
            {
                if(password.count >= 6){
                    userManager.addUser(name: name, birthDate: birthDate, id: id, password: password, isVaccinated: isVaccinated)
                    test2 = id
                    giveName = name
                    return true
                }
            }
        }
        return false
    }

}

struct go_firstView : View {
    var body : some View {
        Home(test2,giveName)
    }
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp()
    }
}
