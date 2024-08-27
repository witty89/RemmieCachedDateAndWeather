//
//  Networking.swift
//  GetWeatherForDate
//
//  Created by Alex on 8/27/24.
//

import Foundation
import Combine

class Networking {
    static let shared = Networking()
    var cancellables = Set<AnyCancellable>()
    
    func get<T: Decodable>(_ url: URL) -> AnyPublisher<T, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .map { data -> Data in
                if let jsonStr = String(data: data, encoding: .utf8) {
                    print("Raw JSON: \(jsonStr)")
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchWeatherData(completion: @escaping (WeatherData?) -> Void) {
        let weatherURL = URL(string: "https://api.openweathermap.org/data/2.5/weather?zip=92618&appid=d9d6b642ca88454a3396830792d4b9a7")!
        
        getWeatherData(url: weatherURL)
            .sink(receiveCompletion: { completionResult in
                switch completionResult {
                case .finished:
                    print("Successfully fetched weather data.")
                case .failure(let error):
                    print("Failed to fetch weather data with error: \(error.localizedDescription)")
                    completion(nil) // Explicitly calling with WeatherData? type
                }
            }, receiveValue: { weatherData in
                completion(weatherData)
            })
            .store(in: &cancellables)
    }
    
    func getWeatherData(url: URL) -> AnyPublisher<WeatherData, Error> {
        return get(url)
    }
}
