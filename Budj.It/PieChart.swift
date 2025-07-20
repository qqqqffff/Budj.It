//
//  BudgetPiChart.swift
//  Budj.It
//
//  Created by Apollo Rowe on 7/15/25.
//

import SwiftUI

struct PieChartData {
    let value: Double;
    let color: Color;
    let label: String;
}

struct PieChart: View {
    let data: [PieChartData]
    let size: CGSize
    let full: Bool
    
    private var total: Double {
        data.reduce(0) { $0 + $1.value }
    }
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: size.width, height: size.height)
                ForEach(0..<data.count, id: \.self) { index in
                    PieChartSlice(
                        startAngle: startAngle(for: index),
                        endAngle: endAngle(for: index),
                        color: data[index].color
                    )
                }
            }
            .frame(width: size.width, height: size.height)
            
            ForEach(0..<data.count, id: \.self) { index in
                
            }
        }
    }
    
    private func startAngle(for index: Int) -> Angle {
        let sum = data.prefix(index).reduce(0) { $0 + $1.value }
        return Angle(degrees: (sum / total) * 360 - 90)
    }
    
    private func endAngle(for index: Int) -> Angle {
        let sum = data.prefix(index + 1).reduce(0) { $0 + $1.value }
        return Angle(degrees: (sum / total) * 360 - 90)
    }
}

struct PieChartSlice: View {
    let startAngle: Angle
    let endAngle: Angle
    let color: Color
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let center = CGPoint(
                    x: geometry.size.width / 2,
                    y: geometry.size.height / 2
                );
                let radius = min(geometry.size.width, geometry.size.height) / 2
                
                path.move(to: center)
                path.addArc(
                    center: center,
                    radius: radius,
                    startAngle: startAngle,
                    endAngle: endAngle,
                    clockwise: false
                )
                path.closeSubpath()
            }
            .fill(color)
        }
    }
}

struct PieChartDataPoint: View {
    let label: String
    let color: Color
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 4)
                .frame(width: 20, height: 20)
                .foregroundColor(color)
                .padding()
            Text(label)
        }
    }
}

#Preview {
    PieChart(
        data: [
            PieChartData(value: 15, color: Color.red, label: "Hello"),
            PieChartData(value: 25, color: Color.orange, label: "World"),
            PieChartData(value: 45, color: Color.blue, label: "Gamer")
        ],
        size: CGSize(width: 250, height: 250),
        full: false
    )
}
