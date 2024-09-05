//
//  ViewModel.swift
//  GetWeatherForDate
//
//  Created by Alex on 8/27/24.
//

import Foundation
import Combine

class ViewModel: ObservableObject {
    var weatherByDate: [Date: (Int, Double)] = [:]
    var cancellables = Set<AnyCancellable>()
    
    func parseWeatherDictionary(date: Date) -> (Int, Double)? {
        return weatherByDate[date]
    }
    
    func fetchWeather(zip: Int, date: Date) -> AnyPublisher<Double?, Never> {
        return Future { promise in
            Networking.shared.fetchWeatherData { weatherData in
                guard let temp = weatherData?.main.temp else {
                    promise(.success(nil))
                    return
                }
                self.weatherByDate[date] = (zip, self.convertKtoF(k: temp))
                promise(.success(temp))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func getWeather(zip: Int, date: Date, completion: @escaping (Double?, String?) -> Void) {
        if let weather = parseWeatherDictionary(date: date) {
            if weather.0 == zip {
                completion(weather.1, nil)
            } else {
                completion(nil, "Can't get weather for that location")
            }
        } else {
            if Calendar.current.isDateInToday(date) {
                fetchWeather(zip: zip, date: date)
                    .sink { temp in
                        let message: String? = temp != nil ? "Weather fetched successfully." : "Failed to fetch weather."
                        completion(temp, message)
                    }
                    .store(in: &cancellables)
            } else {
                completion(nil, "Invalid date")
            }
        }
    }
    
    func convertKtoF(k: Double) -> Double {
        return ((k - 273.15) * 9 / 5 + 32)
    }
}
