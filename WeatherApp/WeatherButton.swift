//
//  WeatherButton.swift
//  SwiftUITut
//
//  Created by Corey Ruhno on 2/26/24.
//

import SwiftUI

struct WeatherButton: View {
    var buttonTitle: String
    var textColor: Color
    var buttonBgroundColor: Color
    var body: some View {
            Text(buttonTitle)
                .frame(width: 280, height: 50)
                .background(buttonBgroundColor)
                .foregroundColor(textColor)
                .font(.system(size: 20))
                .cornerRadius(15)
        }
    }

