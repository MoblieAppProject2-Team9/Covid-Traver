//
//  WeatherService.swift
//  Covid-Traver
//
//  Created by 임승우 on 2023/06/08.
//

import Foundation
import UIKit

class WeatherService{
    var url : String
    init(url : String)
    {
        self.url = url
    }
    
    func fetchJSONData(completion: @escaping (Result<String, Error>) -> Void) { //url로 부터 json string을 가져옴.
        if let url = URL(string: url) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let data = data, let jsonString = String(data: data, encoding: .utf8) {
                    completion(.success(jsonString))
                } else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to parse JSON data"])
                    completion(.failure(error))
                }
            }
            task.resume()
        } else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            completion(.failure(error))
        }
    }

    func parseJSONData(jsonString: String) -> (String, Double, String)? { //json 파일을 파싱함. 원하는 내용 추출
        if let data = jsonString.data(using: .utf8) {
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let name = json["name"] as? String,
                       let main = json["main"] as? [String: Any],
                       let temp = main["temp"] as? Double,
                       let weatherArray = json["weather"] as? [[String: Any]],
                       let weather = weatherArray.first,
                       let description = weather["main"] as? String {
                        
                        return (name, temp, description)
                    }
                }
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
        return nil
    }
    func getWeather(completion: @escaping (String?, Double?) -> Void) {  //일련의 과정은 getWeather을 통해 fetch, parse를 수행.
        fetchJSONData() { [self] result in
            switch result {
            case .success(let jsonString):
                let weather = self.parseJSONData(jsonString: jsonString)
                completion(weather?.0, weather?.1)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                completion(nil, nil)
            }
        }
    }

    
}
