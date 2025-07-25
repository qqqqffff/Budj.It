//
//  BudgetPanel.swift
//  Budj.It
//
//  Created by Apollo Rowe on 7/22/25.
//

import Foundation
import SwiftUI

enum BudgetCategory {
    case Housing
    case Car
    case Food
    case Utilities
    case Loans
    case Credit
    case Saving
    case Investments
    case Transportation
    case Entertainment
    case Subscriptions
    case Shopping
    case Other
}


struct BudgetDataObject {
    let id: UUID
    let category: BudgetCategory
    let amount: Double
    let max: Double
    let color: Color
    let evalMonth: Int
    let evalYear: Int
    var displayPercent: Bool
}


struct BudgetPanel: View {
    @State var data: [BudgetDataObject]
    @State var currentDate: Date = Date()
    
    private var totalAmount: Double {
        data.reduce(0) { $0 + $1.amount }
    }
    
    private var totalMax: Double {
        data.reduce(0) { $0 + $1.max }
    }
    
    private func getDateFormatted() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/yyyy"
        return formatter.string(from: currentDate)
    }

    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("BudgIt Planner")
                    .font(.title)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                    .frame(maxWidth: .infinity)
                
            }
            .overlay(
                HStack{
                    Spacer()
                    Button(action: {
                        
                    }) {
                        Image(systemName: "plus")
                            .font(.title)
                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 10))
                }
            )
            Divider()
            ScrollView {
                let totalOverflow = totalAmount > totalMax
                HStack {
                    Button(action: {
                        if let newDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate) {
                            currentDate = newDate
                        }
                    }) {
                        Image(systemName: "arrow.left.circle")
                            .font(.title2)
                    }
                    Text("\(getDateFormatted())")
                        .font(.title2)
                    Button(action: {
                        if let newDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate) {
                            currentDate = newDate
                        }
                    }) {
                        Image(systemName: "arrow.right.circle")
                            .font(.title2)
                    }
                }
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 1, trailing: 0))
                Text("Total: $\(String(format: "%.2f", totalAmount)) / $\(String(format: "%.2f", totalMax))")
                    .font(.title2)
                    .italic()
                    .foregroundStyle(totalOverflow ? Color.red : Color.black)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
                Divider()
                LazyVStack(spacing: 15) {
                    ForEach(0..<data.count, id: \.self) { index in
                        let overflow = data[index].amount > data[index].max
                        let textColor = overflow ? Color.red : Color.black
                        HStack(alignment: .center, spacing: 10) {
                            getCategoryIcon(category: data[index].category)
                                .imageScale(.large)
                            HStack(spacing: 10) {
                                Text("\(data[index].category):")
                                    .font(.title3)
                                
                                if data[index].displayPercent {
                                    Text("%\(String(format: "%.1f", (data[index].amount / data[index].max) * 100))")
                                        .foregroundStyle(textColor)
                                }
                                else {
                                    Text("$\(String(format: "%.2f", data[index].amount)) / $\(String(format: "%.2f", data[index].max))")
                                        .foregroundStyle(textColor)
                                }
                            }
                            .onTapGesture {
                                data[index].displayPercent.toggle()
                            }
                            Spacer()
                        }
                        .padding(EdgeInsets(top: 15, leading: 20, bottom: 15, trailing: 0))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(data[index].color.opacity(0.2))
                        )
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                    }
                }
                .padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
            }
        }
    }
    
    private func getCategoryIcon(category: BudgetCategory) -> Image {
        switch(category) {
            case .Housing:
                return Image(systemName: "house.fill")
            case .Car:
                return Image(systemName: "car.fill")
            case .Food:
                return Image(systemName: "fork.knife")
            case .Utilities:
                return Image(systemName: "wrench.and.screwdriver.fill")
            case .Loans:
                return Image(systemName: "dollarsign.bank.building")
            case .Transportation:
                return Image(systemName: "road.lanes")
            case .Entertainment:
                return Image(systemName: "ticket")
            case .Subscriptions:
                return Image(systemName: "arrow.trianglehead.clockwise")
            case .Credit:
                return Image(systemName: "creditcard")
            case .Saving:
                return Image(systemName: "shield")
            case .Investments:
                return Image(systemName: "banknote")
            case .Shopping:
                return Image(systemName: "basket")
            case .Other:
                return Image(systemName: "sparkles")
            
        }
    }
}

#Preview {
    BudgetPanel(data: [
        BudgetDataObject(
            id: UUID(),
            category: .Food,
            amount: 1001,
            max: 1000,
            color: Color.orange,
            evalMonth: 7,
            evalYear: 2025,
            displayPercent: false,
        ),
        BudgetDataObject(
            id: UUID(),
            category: .Housing,
            amount: 1000,
            max: 2000,
            color: Color.yellow,
            evalMonth: 7,
            evalYear: 2025,
            displayPercent: false,
        ),
        BudgetDataObject(
            id: UUID(),
            category: .Car,
            amount: 100,
            max: 250,
            color: Color.green,
            evalMonth: 7,
            evalYear: 2025,
            displayPercent: false,
        ),
        BudgetDataObject(
            id: UUID(),
            category: .Utilities,
            amount: 50,
            max: 250,
            color: Color.mint,
            evalMonth: 7,
            evalYear: 2025,
            displayPercent: false,
        ),
        BudgetDataObject(
            id: UUID(),
            category: .Transportation,
            amount: 100,
            max: 250,
            color: Color.teal,
            evalMonth: 7,
            evalYear: 2025,
            displayPercent: false,
        ),
        BudgetDataObject(
            id: UUID(),
            category: .Entertainment,
            amount: 40,
            max: 200,
            color: Color.cyan,
            evalMonth: 7,
            evalYear: 2025,
            displayPercent: false,
        ),
        BudgetDataObject(
            id: UUID(),
            category: .Loans,
            amount: 1500,
            max: 1700,
            color: Color.blue,
            evalMonth: 7,
            evalYear: 2025,
            displayPercent: false,
        ),
        BudgetDataObject(
            id: UUID(),
            category: .Credit,
            amount: 600,
            max: 800,
            color: Color.indigo,
            evalMonth: 7,
            evalYear: 2025,
            displayPercent: false,
        ),
        BudgetDataObject(
            id: UUID(),
            category: .Subscriptions,
            amount: 40,
            max: 100,
            color: Color.purple,
            evalMonth: 7,
            evalYear: 2025,
            displayPercent: false,
        ),
        BudgetDataObject(
            id: UUID(),
            category: .Saving,
            amount: 300,
            max: 600,
            color: Color.pink,
            evalMonth: 7,
            evalYear: 2025,
            displayPercent: false,
        ),
        BudgetDataObject(
            id: UUID(),
            category: .Investments,
            amount: 250,
            max: 500,
            color: Color.brown,
            evalMonth: 7,
            evalYear: 2025,
            displayPercent: false,
        ),
        BudgetDataObject(
            id: UUID(),
            category: .Shopping,
            amount: 25,
            max: 200,
            color: Color.white,
            evalMonth: 7,
            evalYear: 2025,
            displayPercent: false,
        ),
        BudgetDataObject(
            id: UUID(),
            category: .Other,
            amount: 25,
            max: 100,
            color: Color.black,
            evalMonth: 7,
            evalYear: 2025,
            displayPercent: false,
        ),
    ])
}
