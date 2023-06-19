//Created by jeon 23.03.19

import SwiftUI
import Combine

class DestinationsManager: ObservableObject {
    @Published var destinations: [destination] = []
    
    private let destinationsKey = "SavedDestinations" // UserDefaults 키 값
    
    init() {
        loadDestinations()
    }
    
    // 데이터를 UserDefaults에 저장
     func saveDestinations() {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(destinations) {
            UserDefaults.standard.set(encodedData, forKey: destinationsKey)
        }
    }
    
    // UserDefaults에서 데이터를 로드
     func loadDestinations() {
        if let savedData = UserDefaults.standard.data(forKey: destinationsKey) {
            let decoder = JSONDecoder()
            if let loadedDestinations = try? decoder.decode([destination].self, from: savedData) {
                destinations = loadedDestinations
            }
        }
    }
    
    // 여행지 추가
    func addDestination(name: String, departureDate: Date, arrivalDate: Date, departure: String, arrival: String) {
        let newDestination = destination(name: name, departureDate: departureDate, arrivalDate: arrivalDate, departure: departure, arrival: arrival)
        destinations.append(newDestination)
        saveDestinations()
    }
}
