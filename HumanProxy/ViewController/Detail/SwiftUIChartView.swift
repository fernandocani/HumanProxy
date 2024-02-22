//
//  SwiftUIChartView.swift
//  HumanProxy
//
//  Created by Fernando Cani on 20/02/24.
//

import SwiftUI
import Charts

struct AssetHistory: Identifiable {
    let id = UUID()
    let amount: Double
    let createAt: Date
}

@MainActor
class ChartViewModel: ObservableObject {
    
    @Published var selectedX: (any Plottable)?
    var selectedXRuleMark: (date: Date, text: String)? {
        guard let selectedX = self.selectedX as? Date else { return nil }
        let index = DateBins(thresholds: self.list.map( { $0.createAt } )).index(for: selectedX)
        return (selectedX, String(format: "%.2f", self.list[index].amount))
    }
    
    var foregroundMarkColor: Color {
        (selectedX != nil) ? .cyan : .red
    }
    
    let list = [
        AssetHistory(amount: 061.35, createAt: dateFormatter.date(from: "01/01/2024") ?? Date()),
        AssetHistory(amount: 092.40, createAt: dateFormatter.date(from: "02/01/2024") ?? Date()),
        AssetHistory(amount: 083.71, createAt: dateFormatter.date(from: "03/01/2024") ?? Date()),
        AssetHistory(amount: 086.87, createAt: dateFormatter.date(from: "04/01/2024") ?? Date()),
        AssetHistory(amount: 062.54, createAt: dateFormatter.date(from: "05/01/2024") ?? Date()),
        AssetHistory(amount: 078.62, createAt: dateFormatter.date(from: "06/01/2024") ?? Date()),
        AssetHistory(amount: 051.22, createAt: dateFormatter.date(from: "07/01/2024") ?? Date()),
        AssetHistory(amount: 056.07, createAt: dateFormatter.date(from: "08/01/2024") ?? Date()),
        AssetHistory(amount: 140.06, createAt: dateFormatter.date(from: "09/01/2024") ?? Date()),
        AssetHistory(amount: 144.54, createAt: dateFormatter.date(from: "10/01/2024") ?? Date()),
        AssetHistory(amount: 113.89, createAt: dateFormatter.date(from: "11/01/2024") ?? Date()),
        AssetHistory(amount: 083.18, createAt: dateFormatter.date(from: "12/01/2024") ?? Date()),
        AssetHistory(amount: 056.53, createAt: dateFormatter.date(from: "13/01/2024") ?? Date()),
        AssetHistory(amount: 141.01, createAt: dateFormatter.date(from: "14/01/2024") ?? Date()),
        AssetHistory(amount: 060.72, createAt: dateFormatter.date(from: "15/01/2024") ?? Date()),
        AssetHistory(amount: 130.87, createAt: dateFormatter.date(from: "16/01/2024") ?? Date()),
        AssetHistory(amount: 123.15, createAt: dateFormatter.date(from: "17/01/2024") ?? Date()),
        AssetHistory(amount: 082.25, createAt: dateFormatter.date(from: "18/01/2024") ?? Date()),
        AssetHistory(amount: 077.83, createAt: dateFormatter.date(from: "19/01/2024") ?? Date()),
        AssetHistory(amount: 112.42, createAt: dateFormatter.date(from: "20/01/2024") ?? Date()),
        AssetHistory(amount: 069.95, createAt: dateFormatter.date(from: "21/01/2024") ?? Date()),
        AssetHistory(amount: 131.76, createAt: dateFormatter.date(from: "22/01/2024") ?? Date()),
        AssetHistory(amount: 104.93, createAt: dateFormatter.date(from: "23/01/2024") ?? Date()),
        AssetHistory(amount: 147.05, createAt: dateFormatter.date(from: "24/01/2024") ?? Date()),
        AssetHistory(amount: 135.86, createAt: dateFormatter.date(from: "25/01/2024") ?? Date()),
        AssetHistory(amount: 129.31, createAt: dateFormatter.date(from: "26/01/2024") ?? Date()),
        AssetHistory(amount: 144.06, createAt: dateFormatter.date(from: "27/01/2024") ?? Date()),
        AssetHistory(amount: 053.18, createAt: dateFormatter.date(from: "28/01/2024") ?? Date()),
        AssetHistory(amount: 106.60, createAt: dateFormatter.date(from: "29/01/2024") ?? Date()),
        AssetHistory(amount: 075.31, createAt: dateFormatter.date(from: "30/01/2024") ?? Date()),
        AssetHistory(amount: 055.11, createAt: dateFormatter.date(from: "31/01/2024") ?? Date()),
    ]
    
    var minX: Date {
        get {
            self.list.first?.createAt ?? Date()
        }
    }
    
    var maxX: Date {
        get {
            self.list.last?.createAt ?? Date()
        }
    }
    
    static var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yy"
        return df
    }()
    
}

struct SwiftUIChartView: View {

    @ObservedObject var vm: ChartViewModel
    
    var body: some View {
        VStack {
            chart
                .chartXScale(domain: self.vm.minX...self.vm.maxX)
                .chartYScale(domain: 0...150)
                .chartOverlay { proxy in
                    GeometryReader { gProxy in
                        Rectangle().fill(.clear).contentShape(Rectangle())
                            .gesture(DragGesture(minimumDistance: 0)
                                .onChanged { onChangeDrag(value: $0, chartProxy: proxy, geometryProxy: gProxy) }
                                .onEnded { _ in
                                    self.vm.selectedX = nil
                                }
                            )
                    }
                }
        }
        .padding(.top, 36)
        .padding(.horizontal, 16)
    }
    
    var chart: some View {
        Chart(self.vm.list) { item in
            AreaMark(
                x: .value("Month", item.createAt),
                y: .value("Value", item.amount)
            )
            .foregroundStyle(
                LinearGradient(
                    gradient: Gradient(colors: [self.vm.foregroundMarkColor, .clear]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .opacity(0.3)
            
            LineMark(
                x: .value("Month", item.createAt),
                y: .value("Value", item.amount)
            )
            .foregroundStyle(self.vm.foregroundMarkColor)
            .lineStyle(StrokeStyle(lineWidth: 1))
            
            if let (date, text) = self.vm.selectedXRuleMark {
                RuleMark(x: .value("Selected Date", date))
                    .lineStyle(.init(lineWidth: 1))
                    .annotation {
                        VStack {
                            Text(text)
                                .font(.system(size: 14))
                                .foregroundStyle(.blue)
                            Text(date.toString())
                                .font(.system(size: 14))
                                .foregroundStyle(.blue)
                        }
                    }
                    .foregroundStyle(self.vm.foregroundMarkColor)
            }
        }
    }
    
    private func onChangeDrag(value: DragGesture.Value, chartProxy: ChartProxy, geometryProxy: GeometryProxy) {
        guard let plotFrame = chartProxy.plotFrame else { return }
        let locationX = value.location.x
        let originX = geometryProxy[plotFrame].origin.x
        let xCurrent = locationX - originX
        if let index: Date = chartProxy.value(atX: xCurrent),
           index >= self.vm.minX,
           index <= self.vm.maxX {
            self.vm.selectedX = index
        }
    }
    
}

extension Date {
    
    func toString() -> String {
        let df = DateFormatter()
        df.dateFormat = "dd/MM"
        df.locale = Locale(identifier: "en_US")
        return df.string(from: self)
    }
    
}

#Preview {
    SwiftUIChartView(vm: ChartViewModel())
        .frame(height: 200)
        .padding()
}
