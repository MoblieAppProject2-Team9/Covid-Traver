//
//  BottomSheetView.swift
//  Covid-Traver
//
//  Created by 임승우 on 2023/05/30.
//

import SwiftUI
import CoreLocation
import MapKit

struct LineShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        return path
    }
}
struct BottomSheetView: View {
    let hospitalName: String
    let hospitalPhoneNumber: String
    let hospitalCoord:CLLocationCoordinate2D
    let myCoord:CLLocationCoordinate2D
    @Environment(\.presentationMode) var presentationMode
    
    @State private var walkingDuration: TimeInterval = 0
    @State private var drivingDuration: TimeInterval = 0
    @State private var transitDuration: TimeInterval = 0
    @State private var isSelect:Int = 0
    @State private var result:String? = nil
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.gray)
                }
            }
            Text(hospitalName) //병원이름
                .font(.title2)
                .bold()
            LineShape() //실선
                .stroke(.black.opacity(0.5), lineWidth: 2)
                .frame(height: 2)
            HStack{
                Button(action:{ //수화기 버튼
                    print(hospitalPhoneNumber)
                }){
                    Image(systemName: "phone.fill")
                        .foregroundColor(.green)
                        .font(.system(size: 24))
                }.offset(x:10, y:5)
                Text(hospitalPhoneNumber)
                    .font(.system(size: 19))
                    .bold()
                    .offset(x:10, y: 3)
            }
          
            HStack{
                Button(action:{isSelect = 0}) //걷기
                {
                    Image(systemName: "figure.walk")
                        .font(.system(size: 35))
                }
                Spacer()
                Button(action:{isSelect = 1}) //차
                {
                    Image(systemName: "car.fill")
                        .font(.system(size: 35))
                }
                Spacer()
                Button(action:{isSelect = 2}) //대중교통
                {
                    Image(systemName: "bus.fill")
                        .font(.system(size: 35))
                }
            }.frame(width:200)
                .offset(x:60,y:20)
            switch(isSelect)
            {
            case 0:
                Text("소요예상 시간 : \(formattedDuration(walkingDuration))")
                    .font(.system(size: 19))
                    .bold()
                    .position(x:220, y: 40)
            case 1:
                Text("소요예상 시간 : \(formattedDuration(drivingDuration))")
                    .font(.system(size: 19))
                    .bold()
                    .position(x:220, y: 40)
                
            case 2:
                Text("소요예상 시간 : \(formattedDuration(drivingDuration))")
                    .font(.system(size: 19))
                    .bold()
                    .position(x:220, y: 40)
            default:
                Text("소요예상 시간 : \(formattedDuration(walkingDuration))")
                    .font(.system(size: 19))
                    .bold()
                    .position(x:220, y: 40)
            }
            Spacer()
            
            Button(action:{presentationMode.wrappedValue.dismiss()}){
                Text("Done")
                    .foregroundColor(.white)
                    .font(.system(size: 25))
                    .bold()
            }.background(
                Rectangle()
                    .foregroundColor(.blue)
                    .cornerRadius(30)
                    .frame(width:130,height: 45)
            ).offset(x:130, y: -5)
            
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 300)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(.horizontal)
        .padding(.bottom)
        .onAppear {
                   calculateDurations() // Call the function to calculate durations when the view appears
               }
    }
    func calculateDurations() {  //소요시간 계산.
        let sourcePlacemark = MKPlacemark(coordinate: myCoord)
        let destinationPlacemark = MKPlacemark(coordinate: hospitalCoord)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let walkingRequest = MKDirections.Request() //걷는시간
        walkingRequest.source = sourceMapItem
        walkingRequest.destination = destinationMapItem
        walkingRequest.transportType = .walking
        
        let drivingRequest = MKDirections.Request() //운전시간
        drivingRequest.source = sourceMapItem
        drivingRequest.destination = destinationMapItem
        drivingRequest.transportType = .automobile
        
        
        
        let transitRequest = MKDirections.Request() //대중교통시간.
        transitRequest.source = sourceMapItem
        transitRequest.destination = destinationMapItem
        transitRequest.transportType = [.transit]
        
        
        let walkingDirections = MKDirections(request: walkingRequest)
        walkingDirections.calculate { response, error in
            if let route = response?.routes.first {
                self.walkingDuration = route.expectedTravelTime
            }
        }
        
        
        //MKDirections API = 사용가능한 경로중 가장짧은 경로를 찾음. 교통량, 도로상태,신호등 등은 고려 x
        let drivingDirections = MKDirections(request: drivingRequest)
        drivingDirections.calculate { response, error in
            if let route = response?.routes.first {
                self.drivingDuration = route.expectedTravelTime
            }
            
            let transitDirections = MKDirections(request: transitRequest)
            transitDirections.calculate { response, error in
                if let route = response?.routes.first {
                    self.transitDuration = route.expectedTravelTime
                }
                
                // Handle alternate routes if available
                if let routes = response?.routes, routes.count > 1 {
                    for i in 1..<routes.count {
                        let alternateRoute = routes[i]
                        let alternateDuration = alternateRoute.expectedTravelTime
                        // Compare alternateDuration with the existing drivingDuration
                        // and update if it better suits your requirements
                    }
                }
            }
        }
    }
    func formattedDuration(_ duration: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.hour, .minute]
        return formatter.string(from: duration) ?? ""
    }
        
        
}


