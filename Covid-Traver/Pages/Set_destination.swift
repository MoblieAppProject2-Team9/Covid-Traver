//created by jeon 23.03.19


import SwiftUI
import Combine

var testId : String = ""

struct Set_destination: View {
    @StateObject private var destinationsManager = DestinationsManager()
     var name: String = ""            //유저 아이디
    @State private var description: String = ""
    @State private var departureDate = Date()
    @State private var arrivalDate = Date()
    @State private var selectedDeparture = ""
    @State private var selectedArrival = ""

    let cities = ["한국", "일본", "중국", "러시아", "미국", "호주", "아프리카", "영국", "필리핀", "대만"]
    private let destinationsKey = "SavedDestinations"
    
    init(_ id : String){
        self.name = id
        testId = id
        print("id : \(id)")
    }

    var body: some View {
        VStack {
            Spacer()
            Form {
                Section(header: Text("여행지 정보")) {
                    Picker("출발지", selection: $selectedDeparture) {
                        ForEach(cities, id: \.self) { city in
                            Text(city)
                        }
                    }
                    Picker("도착지", selection: $selectedArrival) {
                        ForEach(cities, id: \.self) { city in
                            Text(city)
                        }
                    }
                    //TextField("유저", text: $name)
                    DatePicker("출발 날짜", selection: $departureDate, displayedComponents: .date)
                    DatePicker("도착 날짜", selection: $arrivalDate, displayedComponents: .date)
                }

                Section {
                    Button(action: {
                        if(!selectedDeparture.isEmpty && !selectedArrival.isEmpty){
                            
                        }
                        addDestination()
                    })
                    {
                        Text("추가하기")
                    }
                    //없어도 됨
                    Button(action :{
                        print("name : \(name)")
                    }){Text("확인")}
                }
            }
            Spacer()
            //밑에 어떻게 등록됫는지 출력하는 구문 없어도 됨
            List(destinationsManager.destinations) { destination in
                VStack(alignment: .leading) {
                    Text("아이디 : " + destination.name)
                        .font(.headline)
                    Text("출발 날짜: \(formattedDate(destination.departureDate))")
                    Text("도착 날짜: \(formattedDate(destination.arrivalDate))")
                    Text("출발지: \(destination.departure)")
                    Text("도착지: \(destination.arrival)")
                }
            }
            .padding(.top)
            .frame(maxWidth: .infinity, maxHeight: .infinity)       //여기까지
        }
        .onAppear {
            destinationsManager.loadDestinations()
        }
    }

    func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date)
    }

    func addDestination() {
        let newDestination = destination(name: name, departureDate: departureDate, arrivalDate: arrivalDate, departure: selectedDeparture, arrival: selectedArrival)
        destinationsManager.destinations.append(newDestination)
            destinationsManager.saveDestinations()

       
        description = ""
        departureDate = Date()
        arrivalDate = Date()
        selectedDeparture = ""
        selectedArrival = ""
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Set_destination(testId)
    }
}
