//
//  WeatherConnect.swift
//  SwiftUITut
//
//  Created by Corey Ruhno on 2/26/24.
//

import SwiftUI

class WeatherViewModel: ObservableObject {
    @Published var forcasts: [Forecast] = [Forecast(temp: 55, forecast: "cloud.sun.fill"),
                                           Forecast(temp: 55, forecast: "cloud.sun.fill"),
                                           Forecast(temp: 55, forecast: "cloud.sun.fill"),
                                           Forecast(temp: 55, forecast: "cloud.sun.fill"),
                                           Forecast(temp: 55, forecast: "cloud.sun.fill"),
                                           Forecast(temp: 55, forecast: "cloud.sun.fill")]
    
    let daysOfWeek = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    let imagePicker = ["Sunny": "sun.max.fill",
                       "Chance Snow Showers": "cloud.snow.fill",
                       "Mostly Sunny": "cloud.sun.fill",
                       "Partly Sunny": "cloud.sun.fill",
                       "Chance Rain Showers": "cloud.sun.rain.fill"
    ]
    
    func getWeather() async throws {
        let endpoint = "https://api.weather.gov/gridpoints/DTX/23,90/forecast"
        guard let url = URL(string: endpoint) else { throw NWSError.InvalidURL }
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NWSError.InvalidResponse
        }
        
        
        do {
            print("decoding")
            guard let returned = try? JSONDecoder().decode(NWSTop.self, from: data) else {
                throw NWSError.InvalidData
            }
            
            let nwsData = returned.properties.periods
            var forcasts: Array<Forecast> = []
            
            for day in nwsData {
                if !daysOfWeek.contains(day.name) && day.number != 1 {
                    continue
                }
                let temperature = day.temperature
                let forecastDesc = imagePicker[day.shortForecast] ?? "cloud.sun.fill"
                let forecast = Forecast(temp: temperature, forecast: forecastDesc)
                forcasts.append(forecast)
            }
            self.forcasts = forcasts
        }
        
    }
    
    
    
    enum NWSError: Error {
        case InvalidURL
        case InvalidResponse
        case InvalidData
    }
    
    
    struct NWSTop: Codable {
        let type: String
        let properties: Properties
    }
    
    
    struct Properties: Codable {
        let units: String
        let periods: [Period]
    }
    
    
    struct Period: Codable {
        let number: Int
        let name: String
        let isDaytime: Bool
        let temperature: Int
        let temperatureTrend: String?
        let windSpeed, windDirection: String
        let icon: String
        let shortForecast, detailedForecast: String
    }
    
    
    struct Forecast {
        let temp: Int
        let forecast: String
    }
}
