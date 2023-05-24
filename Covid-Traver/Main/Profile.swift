import SwiftUI
//위쪽에만 cornerness가 들어간 사각형
struct TopRoundedRectangle: Shape {
    let radius: CGFloat

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct Profile: View {
    let Screen_Size = UIScreen.main.bounds //스크린사이즈. Type: CGFloat
    //가로 : Screen_Size.width , 높이:Screen_Size.height
    let User_name:String //유저 이름.
    let User_Country:String? //여행국 정보
    let Travel_Start_Date:String //여행시작 일자
    let Travel_End_Date:String //여행종료 일자
    init(_ name: String, Country:String?, Start:String, End:String) {
        self.User_name = name
        self.User_Country = Country
        self.Travel_Start_Date = Start
        self.Travel_End_Date = End
            
    }
    
    var body: some View {
        VStack{
            ZStack{
                //파란 사각형
                TopRoundedRectangle(radius: 14)
                    .frame(width:360,height:85)
//                    .foregroundColor(.blue)
                    .overlay(GeometryReader { geometry in
                        let gradient = LinearGradient(
                            gradient: Gradient(colors: [Color.blue,
//                                ,Color.white
                                                       ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        
                        gradient
                            .mask(TopRoundedRectangle(radius: 14))
                    })
                    .position(x:Screen_Size.width/2-17 ,y:Screen_Size.height/20)
                //프로필 사진관련
                ZStack{
                    //프로필뒤에 흰색원
                    Circle().fill(.white).frame(width: 200, height:  100)
                    //프로필 사진.
                    Image("Profile")
                        .resizable()
                        .frame(width: 87, height: 87)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }.position(x:70 ,y:70)
                
                
                
            }
            
            //이름
            Text("\(self.User_name)")
                .foregroundColor(.black)
                .font(.system(size:20))
                .bold()
                .position(x:70,y:70)
            
            //여행지
            if let country = User_Country { // 여행지가 설정됨
                VStack(alignment: .leading)
                {
                    //여행지
                    Text("\(country)")
                        .font(.system(size:20))
                        .foregroundColor(.black.opacity(0.7))
                    //여행일자
                    HStack{
                        Text("\(self.Travel_Start_Date)")
                            .font(.system(size:17))
                            .foregroundColor(.black.opacity(0.7))
                        
                        Text("~ \(self.Travel_End_Date)")
                            .font(.system(size:17))
                            .foregroundColor(.black.opacity(0.7))
                    }
                    
                    //여행일정
                    //날씨 (기온, 위치)
                }.offset(x:50, y : -20)
                
                
            }
            else { // 여행지가 설정안됨
                Text("여행지를 설정해주세요")
                    .foregroundColor(.black.opacity(0.7))
                    .font(.system(size:20))
                    .position(x:230,y:10)
            }
           
           
            
            
            
        }.frame(width:360 , height: 170)
            .overlay(RoundedRectangle(cornerRadius: 14)
                .stroke(Color.gray, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 14)) 
            
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile("홍길동님",Country: nil, Start: "", End: "")
        Profile("홍길동님",Country: "Italia", Start: "2023.5.19", End: "2023.5.23")
    }
}
