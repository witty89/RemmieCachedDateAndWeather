//
//  ContentView.swift
//  GetWeatherForDate
//
//  Created by Alex on 8/27/24.
//

import SwiftUI

// Global variable to cache data
// saving the Int zip and Double Temperature based on the date
var weatherByDate = [Date: (Int, Double)]()

struct ContentView: View {
    @StateObject var viewModel: ViewModel
    @State var displayString: String = "Getting weather..."
    
    var body: some View {
        Button(action: {
            let date = Date() // add picker
            viewModel.getWeather(zip: 84043, date: date) { temp, message in
                guard let temperature = temp else {
                    displayString = message ?? "Unknown Error"
                    return
                }
                displayString = String(temperature) + "*"
            }
            
        }, label: {
            Text("Get Weather!")
        })
        Text(displayString)
    }
}
