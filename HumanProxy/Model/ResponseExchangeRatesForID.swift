//
//  ResponseExchangeRatesForID.swift
//  HumanProxy
//
//  Created by Fernando Cani on 20/02/24.
//

import Foundation

// MARK: - ResponseExchangeRatesForID
struct ResponseExchangeRatesForID: Codable, Hashable {
    let assetIDBase: String?
    let rates: [ExchangeRates]?
    
    enum CodingKeys: String, CodingKey {
        case assetIDBase = "asset_id_base"
        case rates = "rates"
    }
}

// MARK: - ExchangeRates
struct ExchangeRates: Codable, Hashable {
    let time: String?
    let assetIDQuote: String?
    let rate: Double?
    
    enum CodingKeys: String, CodingKey {
        case time = "time"
        case assetIDQuote = "asset_id_quote"
        case rate = "rate"
    }
    
    func priceUSDtoCurrency(locale: Locale = Locale(identifier: "en_US")) -> String {
        guard let value = self.rate else { return "--"}
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = locale
        let formattedValue = currencyFormatter.string(from: value as NSNumber)
        return formattedValue ?? "--"
    }
    
}

extension ExchangeRates {
    
    static func placeholderArray() -> [ExchangeRates] {
        return [
            ExchangeRates(
                time: "2024-02-19T04:58:30.0000000Z", 
                assetIDQuote: "$BTH",
                rate: 4598957.7094893910975639443785
            ),
            ExchangeRates(
                time: "2024-02-19T04:58:30.0000000Z",
                assetIDQuote: "$BURN",
                rate: 4214327285.191745000211119538
            ),
            ExchangeRates(
                time: "2024-02-19T04:58:30.0000000Z",
                assetIDQuote: "$CCX",
                rate: 11461790.508817697344207648723
            ),
            ]
    }
    
    static func placeholder1() -> ExchangeRates {
        return ExchangeRates(
            time: "2024-02-19T04:58:30.0000000Z", 
            assetIDQuote: "$BTH",
            rate: 4598957.7094893910975639443785
        )
    }
    
    static func placeholder2() -> ExchangeRates {
        return ExchangeRates(
            time: "2024-02-19T04:58:30.0000000Z",
            assetIDQuote: "$BURN",
            rate: 4214327285.191745000211119538
        )
    }
    
}
