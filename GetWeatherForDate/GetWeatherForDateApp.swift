//
//  GetWeatherForDateApp.swift
//  GetWeatherForDate
//
//  Created by Alex on 8/27/24.
//

import SwiftUI

@main
struct GetWeatherForDateApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ViewModel())
        }
    }
}
