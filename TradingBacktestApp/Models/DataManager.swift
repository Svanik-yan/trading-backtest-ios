import Foundation

class DataManager: ObservableObject {
    @Published var stocks: [Stock] = []
    @Published var dailyData: [String: [DailyStockData]] = [:]
    
    init() {
        loadStockList()
    }
    
    private func loadStockList() {
        guard let url = Bundle.main.url(forResource: "stock_list", withExtension: "txt", subdirectory: "public"),
              let data = try? Data(contentsOf: url),
              let response = try? JSONDecoder().decode(StockListResponse.self, from: data) else {
            print("Failed to load stock list")
            return
        }
        stocks = response.data
    }
    
    func loadDailyData(for stockCode: String) {
        guard let url = Bundle.main.url(forResource: stockCode, withExtension: "txt", subdirectory: "public/daily_stock_data") else {
            print("Failed to find daily data for \(stockCode)")
            return
        }
        
        let lines = try? String(contentsOf: url, encoding: .utf8).components(separatedBy: .newlines)
        guard let lines = lines, lines.count > 1 else { return }
        
        var dailyDataArray: [DailyStockData] = []
        let headers = lines[0].split(separator: ",")
        
        for line in lines.dropFirst() where !line.isEmpty {
            let values = line.split(separator: ",")
            guard values.count == headers.count else { continue }
            
            let data = DailyStockData(
                tsCode: String(values[0]),
                tradeDate: String(values[1]),
                open: Double(values[2]) ?? 0,
                high: Double(values[3]) ?? 0,
                low: Double(values[4]) ?? 0,
                close: Double(values[5]) ?? 0,
                preClose: Double(values[6]) ?? 0,
                change: Double(values[7]) ?? 0,
                pctChg: Double(values[8]) ?? 0,
                vol: Double(values[9]) ?? 0,
                amount: Double(values[10]) ?? 0
            )
            dailyDataArray.append(data)
        }
        
        DispatchQueue.main.async {
            self.dailyData[stockCode] = dailyDataArray
        }
    }
} 