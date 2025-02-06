import Foundation

// 股票基本信息
struct Stock: Codable, Identifiable, Equatable {
    let id = UUID()
    let ticker: String
    let name: String
    let isActive: Int
    let exchangeCode: String
    let countryCode: String
    let currencyCode: String
    
    enum CodingKeys: String, CodingKey {
        case ticker
        case name
        case isActive = "is_active"
        case exchangeCode = "exchange_code"
        case countryCode = "country_code"
        case currencyCode = "currency_code"
    }
    
    static func == (lhs: Stock, rhs: Stock) -> Bool {
        return lhs.ticker == rhs.ticker
    }
}

// 股票日线数据
struct DailyStockData: Codable, Identifiable {
    let id = UUID()
    let tsCode: String
    let tradeDate: String
    let open: Double
    let high: Double
    let low: Double
    let close: Double
    let preClose: Double
    let change: Double
    let pctChg: Double
    let vol: Double
    let amount: Double
    
    enum CodingKeys: String, CodingKey {
        case tsCode = "ts_code"
        case tradeDate = "trade_date"
        case open, high, low, close
        case preClose = "pre_close"
        case change
        case pctChg = "pct_chg"
        case vol, amount
    }
}

// 股票列表响应
struct StockListResponse: Codable {
    let msg: String
    let code: Int
    let data: [Stock]
} 