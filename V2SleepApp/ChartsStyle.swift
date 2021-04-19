//
//  ChartsStyle.swift
//  ChartsSwiftUI
//
//  Created by Alex Nagy on 02.12.2020.
//

import SwiftUI
import SwiftUICharts

struct Style {
    
    static let sleepStyle = ChartStyle(backgroundColor: Color(UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.00)), accentColor: Color(UIColor(red: 0.40, green: 0.71, blue: 1.00, alpha: 1.00)), secondGradientColor: Color(UIColor(red: 0.04, green: 0.22, blue: 0.39, alpha: 1.00)), textColor: Color.black, legendTextColor: Color.pink, dropShadowColor: Color.green)
    static let mentoring = ChartStyle(backgroundColor: Color.pink, accentColor: .yellow, gradientColor: GradientColor(start: Color.blue, end: .blue), textColor: .black, legendTextColor: .blue, dropShadowColor: .blue)
}




