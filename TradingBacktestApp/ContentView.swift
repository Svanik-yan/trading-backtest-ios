import SwiftUI
import Charts

struct ContentView: View {
    @StateObject private var dataManager = DataManager()
    @State private var selectedStock: Stock?
    @State private var initialCapital: String = "100000"
    @State private var showingStockPicker = false
    
    var body: some View {
        NavigationView {
            VStack {
                // 策略设置
                Form {
                    Section(header: Text("策略设置")) {
                        // 股票选择
                        HStack {
                            Text("股票代码")
                            Spacer()
                            Button(selectedStock?.ticker ?? "请选择") {
                                showingStockPicker = true
                            }
                        }
                        
                        // 初始资金
                        TextField("初始资金", text: $initialCapital)
                            .keyboardType(.numberPad)
                    }
                    
                    // 数据展示
                    if let stock = selectedStock,
                       let data = dataManager.dailyData[stock.ticker] {
                        Section(header: Text("价格走势")) {
                            Chart(data) { item in
                                LineMark(
                                    x: .value("日期", item.tradeDate),
                                    y: .value("收盘价", item.close)
                                )
                            }
                            .frame(height: 200)
                        }
                        
                        Section(header: Text("交易统计")) {
                            HStack {
                                Text("最新价")
                                Spacer()
                                Text(String(format: "%.2f", data.last?.close ?? 0))
                            }
                            HStack {
                                Text("涨跌幅")
                                Spacer()
                                Text(String(format: "%.2f%%", data.last?.pctChg ?? 0))
                            }
                        }
                    }
                }
            }
            .navigationTitle("交易回测")
            .sheet(isPresented: $showingStockPicker) {
                StockPickerView(stocks: dataManager.stocks, selectedStock: $selectedStock)
            }
            .onChange(of: selectedStock, { oldValue, newValue in
                if let stock = newValue {
                    dataManager.loadDailyData(for: stock.ticker)
                }
            })
        }
    }
}

struct StockPickerView: View {
    let stocks: [Stock]
    @Binding var selectedStock: Stock?
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""
    
    var filteredStocks: [Stock] {
        if searchText.isEmpty {
            return stocks
        } else {
            return stocks.filter { $0.ticker.contains(searchText) || $0.name.contains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            List(filteredStocks) { stock in
                Button(action: {
                    selectedStock = stock
                    dismiss()
                }) {
                    VStack(alignment: .leading) {
                        Text("\(stock.ticker) \(stock.name)")
                            .foregroundColor(.primary)
                    }
                }
            }
            .searchable(text: $searchText, prompt: "搜索股票")
            .navigationTitle("选择股票")
            .navigationBarItems(trailing: Button("取消") {
                dismiss()
            })
        }
    }
}

#Preview {
    ContentView()
} 