import SwiftUI
import CoreLocation
import UIKit
//위쪽에만 cornerness가 들어간 사각형
struct TopRoundedRectangle: Shape {
    let radius: CGFloat

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

//날씨 그룹
enum WeatherGroup: String {
    case thunderstorm = "Thunderstorm"
    case drizzle = "Drizzle"
    case rain = "Rain" //drizzle과 동일
    case snow = "Snow"
    case mist = "Mist"
    case smoke = "Smoke" //mist와 동일
    case haze = "Haze" //mist와 동일
    case dust = "Dust"
    case fog = "Fog"
    case sand = "Sand" //dust와 동일
    case ash = "Ash"
    case squall = "Squall" //tornado 와 동일
    case tornado = "Tornado"
    case clear = "Clear"
    case clouds = "Clouds"
}


struct Profile: View {
    let Screen_Size = UIScreen.main.bounds //스크린사이즈. Type: CGFloat
    //가로 : Screen_Size.width , 높이:Screen_Size.height
    let User_name:String //유저 이름.
    let User_Country:String? //여행국 정보
    let Travel_Start_Date:String //여행시작 일자
    let Travel_End_Date:String //여행종료 일자
    var latitude: Double //위도
    var longitude: Double //경도
    @State private var cityName: String = "" //지역이름
    @State private var temperature: Double = 0.0 //온도(켈빈온도)
    @State private var weather = "" //날씨 정보
    @State private var jsonString: String = "" //json Parsing시 사용할 스트링
    //open weather api
    let baseURL: String = "https://api.openweathermap.org/data/2.5/weather?"
    let API_KEY: String = "&appid=4e76f180635b7e54eea1a16bde7b4fb4"
    var _URL: String
    let weatherService: WeatherService
    init(_ name: String, Country:String?, Start:String, End:String, latitude:Double, longitude:Double) {
        self.User_name = name
        self.User_Country = Country
        self.Travel_Start_Date = Start
        self.Travel_End_Date = End
        self.latitude = latitude
        self.longitude = longitude
        self._URL = baseURL + "lat=\(latitude)" + "&lon=\(longitude)" + API_KEY
        self.weatherService = WeatherService(url: _URL)
        
    }
    @State var weather_IMG : String = ""

    var body: some View {
        VStack{
            ZStack{
                //파란 사각형
                TopRoundedRectangle(radius: 14)
                    .frame(width:360,height:70)
//                    .foregroundColor(.blue)
                    .overlay(GeometryReader { geometry in
                        let gradient = LinearGradient(
                            gradient: Gradient(colors: [Color.blue,
//                                Color.white
                                                       ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        gradient.mask(TopRoundedRectangle(radius: 14))
//                        ZStack {
//                                       gradient
//                                       Image("pp")
//                                           .resizable()
//                                           .aspectRatio(contentMode: .fill)
//                                           .frame(width: geometry.size.width, height: geometry.size.height)
//                                           .mask(TopRoundedRectangle(radius: 14))
//                                   }
                        })
                    .position(x:Screen_Size.width/2-17 ,y:Screen_Size.height/25)
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
                .position(x:70,y:90)
            
            //여행지
            if let country = User_Country { // 여행지가 설정됨
                VStack(alignment: .leading)
                {
                    //여행지
                    
                    Text("\(country)")
                        .font(.system(size:25))
                        .foregroundColor(.black.opacity(0.7))
                        .offset(y:30)
                    //여행일자
                    HStack{
                        Text("\(self.Travel_Start_Date)")
                            .font(.system(size:17))
                            .foregroundColor(.black.opacity(0.7))
                        
                        Text("~ \(self.Travel_End_Date)")
                            .font(.system(size:17))
                            .foregroundColor(.black.opacity(0.7))
                    }.offset(y:30)
                    
                    //여행일정
                    //날씨 (기온, 위치)
                }.offset(x:50, y : -20)
                
                
            }
            else { // 여행지가 설정안됨
                Text("여행지를 설정해주세요")
                    .foregroundColor(.black.opacity(0.7))
                    .font(.system(size:20))
                    .position(x:230,y:30)
            }
           
           //날씨 관련
            VStack{
//                Text("\(weather)").font(.title)
                Image("\(weather_IMG)").resizable()
                    .frame(width: 40, height:  40)
                Text(String(format: "%.1f °C", temperature - 273.15))
                    .font((.subheadline))
                    .bold()
                    .foregroundColor(.white)
                    .offset(y:-6)
            }.onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.weatherService.fetchJSONData{result in
                        switch result{
                        case .success(let jsonString):
                            self.jsonString = jsonString
                            self.fetchWeatherData()
                        case .failure(let error):
                            print(error)

                        }

                    }
                }

            }.position(x:300, y:-97)
                
            
        }.frame(width:360 , height: 170)
            .overlay(RoundedRectangle(cornerRadius: 14)
                .stroke(Color.gray, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 14))
            
    }
    func fetchWeatherData() -> Void{
//        let url = baseURL + "lat=\(self.latitude)" + "&lon=\(self.longitude)" + API_KEY
        weatherService.url = _URL
        weatherService.getWeather { name, temp in
                 DispatchQueue.main.async {
                     cityName = name ?? ""
                     temperature = temp ?? 0.0 //kelvin -> celius
                    
                     if let description = self.weatherService.parseJSONData(jsonString: self.jsonString)?.2 {
                         weather = description
                         
                     }
                     
                     
                     switch weather {
                     case WeatherGroup.thunderstorm.rawValue:
                         weather_IMG = "lightning"
                     case WeatherGroup.drizzle.rawValue:
                         weather_IMG = "drizzle"
                     case WeatherGroup.rain.rawValue:
                         weather_IMG = "drizzle"
                     case WeatherGroup.snow.rawValue:
                         weather_IMG = "snow"
                     case WeatherGroup.mist.rawValue:
                         weather_IMG = "mist"
                     case WeatherGroup.haze.rawValue:
                         weather_IMG = "mist"
                     case WeatherGroup.smoke.rawValue:
                         weather_IMG = "mist"
                     case WeatherGroup.dust.rawValue:
                         weather_IMG = "sandstorm"
                     case WeatherGroup.fog.rawValue:
                         weather_IMG = "fog"
                     case WeatherGroup.sand.rawValue:
                         weather_IMG = "sandstorm"
                     case WeatherGroup.ash.rawValue:
                         weather_IMG = "volcano"
                     case WeatherGroup.squall.rawValue:
                         weather_IMG = "tornado"
                     case WeatherGroup.tornado.rawValue:
                         weather_IMG = "tornado"
                     case WeatherGroup.clear.rawValue:
                         weather_IMG = "sun"
                     case WeatherGroup.clouds.rawValue:
                         weather_IMG = "clouds"
                     default:
                         weather_IMG = ""
                     }

                     //debug
                     print(latitude)
                     print(longitude)
                     print(_URL)
                     print(cityName)
                     print(temperature - 273.15)
                     print(weather)
                 }
             }
    }
}
    

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile("홍길동님",Country: nil, Start: "", End: "",latitude: 0,longitude: 0)
        Profile("홍길동님",Country: "Italia", Start: "2023.5.19", End: "2023.5.23",latitude: 0,longitude: 0)
    }
}
