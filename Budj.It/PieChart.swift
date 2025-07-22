//
//  BudgetPiChart.swift
//  Budj.It
//
//  Created by Apollo Rowe on 7/15/25.
//

import SwiftUI

struct PieChartData {
    let max: Double;
    let value: Double;
    let color: Color;
    let label: String;
}

struct PieChart: View {
    let data: [PieChartData]
    let size: CGSize
    @State var metrics: Bool
    @State var totalPercent: Bool
    
    private var total: Double {
        data.reduce(0) { $0 + $1.max }
    }
    private var totalValue: Double {
        data.reduce(0) { $0 + $1.value }
    }
    
    var body: some View {
        VStack(spacing: 20){
            ZStack {
                ForEach(0..<data.count, id: \.self) { index in
                    let sAngle = startAngle(for: index)
                    let eAngle = endAngle(for: index)
                    
                    PieChartSlice(
                        startAngle: sAngle,
                        endAngle: eAngle,
                        color: Color.gray.opacity(0.6),
                        border: true
                    )
                }
                ForEach(0..<data.count, id: \.self) { index in
                    let sAngle = startAngle(for: index)
                    let eAngle = endAngle(for: index)
                    if(data[index].value > data[index].max) {
                        PieChartSlice(
                            startAngle: sAngle,
                            endAngle: Angle(degrees: eAngle.degrees - 0.5),
                            color: Color.red,
                            border: false
                        )
                    }
                    else {
                        let multiplier = Double(data[index].value / data[index].max)
                        let dataAngle = Angle(degrees: sAngle.degrees + (eAngle.degrees - sAngle.degrees) * multiplier)
                        
                        PieChartSlice(
                            startAngle: sAngle,
                            endAngle: dataAngle,
                            color: data[index].color,
                            border: false
                        )
                    }
                }
                Circle()
                    .fill(Color.black)
                    .frame(width: size.width - 40, height: size.height - 40)
                Circle()
                    .fill(Color.white)
                    .frame(width: size.width - 44, height: size.height - 44)
                VStack(spacing: 5) {
                    let overflow = totalValue > total
                    let textColor = overflow ? Color.red : Color.black
                    if totalPercent {
                        Text("%\(String(format: "%.1f", Double(totalValue / total) * 100))")
                            .foregroundStyle(textColor)
                            .font(Font.title)
                    }
                    else {
                        Text("$\(String(format: "%.2f", totalValue))")
                            .font(Font.title2)
                            .foregroundStyle(textColor)
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                        Rectangle()
                            .frame(height: 1)
                            .foregroundStyle(.black.opacity(0.8))
                        Text("$\(String(format: "%.2f", total))")
                            .font(Font.title2)
                            .foregroundStyle(textColor)
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                    }
                    
                }
                .fixedSize(horizontal: true, vertical: false)
                .onTapGesture {
                    totalPercent = !totalPercent
                }
            }
            .frame(width: size.width, height: size.height)
            
            if data.count < 5 && metrics {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(0..<data.count, id: \.self) { index in
                        PieChartDataPoint(
                            data: data[index]
                        )
                    }
                }
            }
            else if metrics {
                HStack(spacing: 50) {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(0..<Int(data.count / 2), id: \.self) { index in
                            PieChartDataPoint(
                                data: data[index]
                            )
                        }
                    }
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(Int(data.count / 2)..<data.count, id: \.self) { index in
                            PieChartDataPoint(
                                data: data[index]
                            )
                        }
                    }
                }
            }
        }
    }
    
    private func startAngle(for index: Int) -> Angle {
        let sum = data.prefix(index).reduce(0) { $0 + $1.max }
        return Angle(degrees: (sum / total) * 360 - 90)
    }
    
    private func endAngle(for index: Int) -> Angle {
        let sum = data.prefix(index + 1).reduce(0) { $0 + $1.max }
        return Angle(degrees: (sum / total) * 360 - 90)
    }
}

struct PieChartSlice: View {
    let startAngle: Angle
    let endAngle: Angle
    let color: Color
    let border: Bool
    
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
            if border {
                Path { path in
                    let center = CGPoint(
                        x: geometry.size.width / 2,
                        y: geometry.size.height / 2
                    )
                    let radius = min(geometry.size.width, geometry.size.height) / 2 + 1
                    
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
                .stroke(Color.black, lineWidth: 2)
            }
        }
    }
}

struct PieChartDataPoint: View {
    let data: PieChartData
    @State var displayStyle: Bool = false
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 4)
                .frame(width: 20, height: 20)
                .foregroundColor(data.color)
            let overflow = data.value > data.max
            let textColor = overflow ? Color.red : Color.black
            if(displayStyle) {
                Text("\(data.label): \(String(format: "%.1f", Double(data.value/data.max) * 100))%")
                    .foregroundStyle(textColor)
            }
            else {
                Text("\(data.label): $\(String(format: "%.2f", data.value)) / $\(String(format: "%.2f", data.max))")
                    .foregroundStyle(textColor)
            }
        }.onTapGesture {
            displayStyle = !displayStyle
        }
    }
}

#Preview {
    PieChart(
        data: [
            PieChartData(
                max: 100,
                value: 200,
                color: Color.yellow,
                label: "Food"
            ),
            PieChartData(
                max: 100,
                value: 50,
                color: Color.orange,
                label: "Rent"
            ),
            PieChartData(
                max: 50,
                value: 45,
                color: Color.blue,
                label: "Utilities"
            ),
            PieChartData(
                max: 50,
                value: 32,
                color: Color.purple,
                label: "Lebron"
            )
        ],
        size: CGSize(width: 250, height: 250),
        metrics: true,
        totalPercent: false,
    )
}
