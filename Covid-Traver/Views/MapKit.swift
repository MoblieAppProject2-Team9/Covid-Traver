import SwiftUI
import MapKit
import CoreLocation


//내 위치 관련 클래스.->위치권한.



//지도와 관련된 메인뷰.
struct MapView: UIViewRepresentable {
    @EnvironmentObject private var locationManager: LocationManager
    @State private var hospitals: [MKMapItem] = [] //병원등의 아이템을 담을 변수.
    let findKeyword: String? //찾을  키워드 ex. 병원
    
    @State private var meters : Double = 2000//미터 반경
    init(findKeyword:String?)
    {
        self.findKeyword = findKeyword

    }
    @State private var isSheetPresented = false //병원클릭시 시트가 출력되게하는 변수.
    //좌표 초기화
    var coordinate: CLLocationCoordinate2D? { //내 기기의 좌표를 불러서 좌표변수를 생성. (기기 좌표 ->변수 좌표) 변환
        guard locationManager.latitude != 0, locationManager.longitude != 0 else {
            return nil
        }
        return CLLocationCoordinate2D(latitude: locationManager.latitude, longitude: locationManager.longitude)
    }
    var searchRegion: MKCoordinateRegion? { //내 좌표에서 지도 얼마나 보여줄것인가?
        guard let coordinate = coordinate else {
            return nil
        }
        return MKCoordinateRegion(center: coordinate, latitudinalMeters: meters, longitudinalMeters: meters)
    }
    
    //지도와 관련된 Uiview를 생성.
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        //mapView.showsPointsOfInterest = false
        return mapView
    }
    //뷰를 업데이트. (지도를 그리는것)
    func updateUIView(_ uiView: MKMapView, context: Context)
    {
        guard let coordinate = coordinate, let searchRegion = searchRegion else {return}//nil 검사.
        
        uiView.setRegion(searchRegion, animated: false) //지도에 내 위치를 set함.
        
        //찾는 단어가 있을때 (병원)
        if findKeyword != nil && locationManager.latitude != 0 && locationManager.longitude != 0 {
            if hospitals.isEmpty { //병원 아이템에 아무것도없다면 병원을 먼저검색
                searchForHospitals(mapView: uiView, coordinate: coordinate)
            } else { //병원아이템이 안 비어있다면 병원마커를 지도에 추가.
                addHospitalsToMap(mapView: uiView)
            }
            
            //디버깅용도
            for hospital in hospitals {
                if let name = hospital.name {
                    print(name)
                }
            }
        }
       
    }
    //주변에 병원을 찾음.
    func searchForHospitals(mapView: MKMapView, coordinate: CLLocationCoordinate2D) {
        //찾는지역은 내 위치좌표를 기준. (내 위치좌표는 위에서 meters변수로 반경미터를 설정하였었음)
        guard let keyword = findKeyword, let searchRegion = searchRegion else {
            return
        }
        
        let request = MKLocalSearch.Request() //지도 검색요청에 사용되는 클래스.
        request.naturalLanguageQuery = keyword //검색내용(키워드)
        request.region = searchRegion //검색할 지역
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response, error == nil else {
                print("Error searching for \(keyword): \(error?.localizedDescription ?? "")")
                return
            }
            //response 의 갯수가 다름
            self.hospitals = response.mapItems //검색해서 반환된 아이템을 hospitals변수에 카피.
            self.addHospitalsToMap(mapView: mapView) //맵에 병원을 업데이트.
        }
    }
    
    //맵에 병원을 업데이트함.
    func addHospitalsToMap(mapView: MKMapView) {
        mapView.removeAnnotations(mapView.annotations)
        for hospital in hospitals {
            //annotation = 지도마커
            let annotation = MKPointAnnotation()
            annotation.title = hospital.name
            annotation.subtitle = hospital.phoneNumber
            annotation.coordinate = hospital.placemark.coordinate
            mapView.addAnnotation(annotation) //맵뷰에 어노테이션을 추가(마커를 추가)
        }
    }
    
    //UIviewRepresentable을 채택한다면 구현해야함.
    func makeCoordinator() -> Coordinator {
        Coordinator(hospitals: hospitals, locationManager: locationManager)
    }
    
    //MKMapViewDelegate 프로토콜 오버라이드.
    //MapView구조체 내부에서 생성되는 독립적인 클래스여서 멤버변수에 직접적으로 접근불가.
    class Coordinator: NSObject, MKMapViewDelegate {
        var hospitals: [MKMapItem]
        var locationManager: LocationManager
        init(hospitals: [MKMapItem], locationManager: LocationManager) {
            self.hospitals = hospitals
            self.locationManager = locationManager
        }
        
        //병원 마커 annotation 설정
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? //맵 마커관련. annotation.
        {
            guard annotation is MKPointAnnotation else {
                return nil
            }
            
            let identifier = "HospitalMarker"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
            
            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true    // 터치하였을때 정보표시 여부
                annotationView?.rightCalloutAccessoryView = UIButton(type: .infoLight) // 도움마커를 표시
            } else {
                annotationView?.annotation = annotation
            }
            annotationView?.glyphImage =  UIImage(systemName: "cross.case.circle.fill") //병원마커
            annotationView?.markerTintColor = UIColor.red //마커 색깔
            return annotationView
        }
         
        //병원 마커를 클릭하였을때 동작설정.
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            if control == view.rightCalloutAccessoryView {
                if let annotation = view.annotation as? MKPointAnnotation {
                    let hospitalName = annotation.title ?? "" //병원이름
                    let hospitalPhoneNumber = annotation.subtitle ?? "" //병원전화번호
                    let hospitalCoordinate = annotation.coordinate //병원좌표
                    let myCoordinate = CLLocationCoordinate2D(latitude: locationManager.latitude, longitude: locationManager.longitude) //내좌표를 변수로.
                    
                    
                    let bottomSheetView = BottomSheetView(hospitalName: hospitalName, hospitalPhoneNumber: hospitalPhoneNumber, hospitalCoord: hospitalCoordinate, myCoord: myCoordinate)
                    
                    let hostingController = UIHostingController(rootView: bottomSheetView)
                    hostingController.modalPresentationStyle = .overCurrentContext  //현재 맵뷰를 바텀시트가 덮음.
                    hostingController.view.backgroundColor = .clear
                    
                    if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
                        window.rootViewController?.present(hostingController, animated: true, completion: nil)
                    }
                }

            }
            
        }//func


        
    }//class

}//struct


struct Map_kit: View {
    let width:CGFloat
    let height:CGFloat
    @StateObject var my_location = LocationManager() //Location Manager()라는 클래스에 의존성을 가짐.(Map_kit 뷰 외부 뷰에 의존성을 가짐)
    //여기서 인스턴스를 생성하고, 이 Map_kit뷰 안에서만 사용가능. 이 뷰를 다른뷰에서 접근 수정할수있게함. -> 다른뷰에서 수정하게 environmentObject로 넘겨줌.
    let find_keyword:String? //찾는건물
    @State private var distance: Double = 2000
    init(width:CGFloat, height:CGFloat, _ keyword: String?)
    {
        self.width = width
        self.height = height
        self.find_keyword = keyword
    }
    @ViewBuilder
    var body: some View {
        ZStack{
            if self.find_keyword == nil  //찾는 정보(ex병원) 이없음. 내위치만 디스플레이.
            {
                MapView(findKeyword: nil)
                    .environmentObject(my_location)
                    .frame(width:self.width, height:self.height)
                    .onAppear {my_location.locationManager.requestLocation()}
            }
            else //병원을 찾음.
            {
                MapView(findKeyword: "Hospital")
                    .environmentObject(my_location)
                    .frame(width:self.width, height:self.height)
                    .onAppear {
                        my_location.locationManager.requestLocation()
                        
                    }
            }
            
           
        }
        
    }
}


