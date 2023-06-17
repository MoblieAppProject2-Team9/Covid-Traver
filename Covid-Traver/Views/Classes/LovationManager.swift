//
//  LocationManager.swift
//  Covid-Traver
//
//  Created by 임승우 on 2023/06/08.
//

import Foundation
import MapKit
import CoreLocation

class LocationManager: NSObject,CLLocationManagerDelegate, ObservableObject{
    //NSObject : 위치액세스가 필요한 설명 포함. CLLocationManagerDelegate : 옵션. 항상 옵션이 필요한경우.
    let locationManager = CLLocationManager()
    @Published var latitude :  Double = 0
    @Published var longitude :  Double = 0
    override init(){
        super.init()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //위치데이터에 대해 가장 높은 정확도 수준 설정.
        locationManager.requestWhenInUseAuthorization() //위치접근권한 요청->앱 처음실행시 아마 권한 관련 허용창이 뜰것.
        locationManager.startUpdatingLocation()
    }

    //위치접근에 대한 권한이 변경되었을때 호출
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
          if status == .authorizedWhenInUse {
              locationManager.requestLocation()
          }
      }
    //새 위치업데이트를 사용할수있을때 호출.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      if let location = locations.last {
          latitude = location.coordinate.latitude
          longitude = location.coordinate.longitude
          
           // print("Latitude: \(latitude), Longitude: \(longitude)") - 디버깅용.

      }

    }
    //에러시 호출.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
      print("Failed to get location: \(error.localizedDescription)")
    }
}
