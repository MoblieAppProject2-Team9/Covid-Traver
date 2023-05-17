import SwiftUI
import MapKit
import CoreLocation

struct MapItem: Identifiable {
    let id = UUID()
    let mapItem: MKMapItem
}

extension MKMapItem: Identifiable {
    public var id: String {
        return name ?? UUID().uuidString
    }
}
//위치 관리자 클래스.
class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    private let locationManager = CLLocationManager()

    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 35.887402, longitude: 128.611858),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )

    var contentView: MapView?

    override init() {
        super.init()

        locationManager.delegate = self //delegate : 객체간의 상호작용을 위해사용.
        //CLLocationManager객체가 위치정보를 업데이트할때 감지후 처리.
        locationManager.requestWhenInUseAuthorization() //위치권한요청.
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! // 최근 위치를 가져옴.
        // 이 위치를 기준으로 맵뷰 형성.
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000) //longitudinalMeters 1000미터만 보여줌.
        // region을 MapView의 @State 변수로 업데이트
        contentView?.region = region
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }

    func fetchCurrentLocation() {
        locationManager.requestLocation()
    }
}

struct MapView: View {
    @State public var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 35.887402, longitude: 128.611858),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    @State private var searchText: String = ""//검색내용. hospital
    @State private var places: [MKMapItem] = [] //병원을 검색했을때, item을 담는 배열.
    	
    @State private var showMyLocation = false
    @State private var annotation: MKPointAnnotation? //내 위치
    @State private var locationManager = LocationManager() //위치관리자.
    private var width: CGFloat = 300
    private var height: CGFloat = 200
    init(width: CGFloat, height : CGFloat)
    {
        self.width = width
        self.height = height
    }
    var body: some View {
        VStack {
            TextField("Search", text: $searchText, onCommit: search)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
            
            // 버튼 추가
            Button(action: {
                showMyLocation = true
            }, label: {
                Image(systemName: "location.fill")
            })
            .frame(width: 44, height: 44)
            .background(Color.white)
            .cornerRadius(22)
            .padding(.trailing, 16)
            .shadow(radius: 2.0)
            .padding(.top, -32)
            
            
            Map(coordinateRegion: $region, annotationItems: places) { place in
                MapAnnotation(coordinate: place.placemark.coordinate) {
                    Text(place.name ?? "")
                }
            }
            .edgesIgnoringSafeArea(.all)
            .frame(width:width,height: height)
            .cornerRadius(14)
            .shadow(radius: 1.0)
        }
        // onAppear modifier를 사용해 뷰가 나타날 때 위치 정보를 가져오도록 합니다.
        .onAppear {
            locationManager.contentView = self
        }
        // showMyLocation이 true일 때, 지도 영역을 현재 위치로 변경합니다.
        .onChange(of: showMyLocation) { value in
            if value {
                locationManager.fetchCurrentLocation()
            }
        }
    }
    
    private func search() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        
        // 검색 위치 범위는 현재 지도 영역으로 한정합니다.
        request.region = region
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            guard let response = response else { return }
            self.places = response.mapItems
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(width:300, height : 200)
    }
}



