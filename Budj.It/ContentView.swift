//
//  ContentView.swift
//  Budj.It
//
//  Created by Apollo Rowe on 7/13/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Budj-It")
                .fontWeight(.semibold)
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                .font(Font.title)
            TabView {
                VStack {
                    Text("Budget Maker")
                    Spacer()
                }
                .tabItem {
                    VStack {
                        Image(systemName: "banknote")
                            .imageScale(.small)
                        Text("Budget")
                    }
                }
                VStack {
                    PieChart(
                        data: [
                            PieChartData(value: 15, color: Color.red, label: "Hello"),
                            PieChartData(value: 25, color: Color.orange, label: "World"),
                            PieChartData(value: 45, color: Color.blue, label: "Gamer")
                        ],
                        size: CGSize(width: 250, height: 250),
                        full: false
                    )
                    Spacer()
                }
                .tabItem {
                    VStack {
                        Image(systemName: "house")
                            .imageScale(.small)
                        Text("Home")
                    }
                }
                .tag(2)
                VStack {
                    Text("Bank Integrator")
                    Spacer()
                }
                .tabItem {
                    VStack {
                        Image(systemName: "dollarsign.bank.building")
                            .imageScale(.small)
                        Text("Bank Integration")
                    }
                }
                .tag(3)
            }
        }
    }
}

#Preview {
    ContentView()
}
