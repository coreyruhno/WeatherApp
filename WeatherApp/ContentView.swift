//
//  ContentView.swift
//  SwiftUITut
//
//  Created by Corey Ruhno on 2/26/24.
//

import SwiftUI

struct ContentView: View {
    @State private var isNight = false
    @StateObject var weatherVM = WeatherViewModel()
    var body: some View {
        ZStack {
            BackgroundView(isNight: $isNight)
            VStack {
                CityTextView(cityName: "Midland, MI")
                MainWeatherView(imageName: isNight ? "cloud.moon.fill" : weatherVM.forcasts[0].forecast,
                                temperature: weatherVM.forcasts[0].temp)
                
                HStack(spacing: 20) {
                    WeatherDayView(dayOfWeek: "TUE", weatherImage: weatherVM.forcasts[1].forecast, temperature: weatherVM.forcasts[1].temp)
                    WeatherDayView(dayOfWeek: "WED", weatherImage: weatherVM.forcasts[2].forecast, temperature: weatherVM.forcasts[2].temp)
                    WeatherDayView(dayOfWeek: "THU", weatherImage: weatherVM.forcasts[3].forecast, temperature: weatherVM.forcasts[3].temp)
                    WeatherDayView(dayOfWeek: "FRI", weatherImage: weatherVM.forcasts[4].forecast, temperature: weatherVM.forcasts[4].temp)
                    WeatherDayView(dayOfWeek: "SAT", weatherImage: weatherVM.forcasts[5].forecast, temperature: weatherVM.forcasts[5].temp)
                }
                Spacer()
                Button {
                    isNight.toggle()
                } label: {
                    WeatherButton(buttonTitle: "Change Day Time",
                                  textColor: .black,
                                  buttonBgroundColor: .white)
                }
                Spacer()
            }
            .task {
                do {
                   try await weatherVM.getWeather()
                } catch {
                    
                }
                
            }
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct WeatherDayView: View {
    var dayOfWeek: String
    var weatherImage: String
    var temperature: Int
    
    var body: some View {
        VStack(spacing: 8) {
            Text(dayOfWeek)
                .font(.system(size: 16, weight: .medium, design: .default))
                .foregroundColor(.white)
            Image(systemName: weatherImage)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
            Text("\(temperature)°")
                .font(.system(size: 28, weight: .medium))
                .foregroundColor(.white)
        }
    }
}


struct BackgroundView: View {
    @Binding var isNight: Bool
    var body: some View {
        LinearGradient(gradient: Gradient(
            colors: [isNight ? .black : .blue, isNight ? .gray : Color("lightBlue")]),
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
}


struct CityTextView: View {
    var cityName: String
    var body: some View {
        Text(cityName)
            .font(.system(size: 32, weight: .medium, design: .default))
            .foregroundColor(.white)
            .padding()
    }
}


struct MainWeatherView: View {
    var imageName: String
    var temperature: Int
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: imageName)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 180, height: 180)
            Text("\(temperature)°")
                .font(.system(size: 70, weight: .medium))
                .foregroundColor(.white)
        }
        .padding(.bottom, 40)
    }
}

