//
//  ResponseAssets.swift
//  HumanProxy
//
//  Created by Fernando Cani on 19/02/24.
//

import Foundation

typealias ResponseDetailCoinAPI = [ResponseDetailCoinAPIElement]

// MARK: - ResponsePokemonDetailCoinAPIElement
struct ResponseDetailCoinAPIElement: Codable, Hashable {
    let assetID:            String?
    let name:               String?
    let typeIsCrypto:       Int?
    let dataQuoteStart:     String?
    let dataQuoteEnd:       String?
    let dataOrderbookStart: String?
    let dataOrderbookEnd:   String?
    let dataTradeStart:     String?
    let dataTradeEnd:       String?
    let dataSymbolsCount:   Int?
    let volume1HrsUsd:      Double?
    let volume1DayUsd:      Double?
    let volume1MthUsd:      Double?
    let priceUsd:           Double?
    let idIcon:             String?
    let dataStart:          String?
    let dataEnd:            String?

    enum CodingKeys: String, CodingKey {
        case assetID = "asset_id"
        case name = "name"
        case typeIsCrypto = "type_is_crypto"
        case dataQuoteStart = "data_quote_start"
        case dataQuoteEnd = "data_quote_end"
        case dataOrderbookStart = "data_orderbook_start"
        case dataOrderbookEnd = "data_orderbook_end"
        case dataTradeStart = "data_trade_start"
        case dataTradeEnd = "data_trade_end"
        case dataSymbolsCount = "data_symbols_count"
        case volume1HrsUsd = "volume_1hrs_usd"
        case volume1DayUsd = "volume_1day_usd"
        case volume1MthUsd = "volume_1mth_usd"
        case priceUsd = "price_usd"
        case idIcon = "id_icon"
        case dataStart = "data_start"
        case dataEnd = "data_end"
    }
    
    func priceUSDtoCurrency(locale: Locale = Locale(identifier: "en_US")) -> String {
        guard let value = self.priceUsd else { return "--"}
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = locale
        let formattedValue = currencyFormatter.string(from: value as NSNumber)
        return formattedValue ?? "--"
    }
    
    func getIconURL() -> URL? {
        guard let idIconClean = self.idIcon?.replacingOccurrences(of: "-", with: "") else {
            return nil
        }
        return URL(string: "https://s3.eu-central-1.amazonaws.com/bbxt-static-icons/type-id/png_512/\(idIconClean).png")
    }
    
}

extension ResponseDetailCoinAPIElement {
    
    static func placeholder1() -> ResponseDetailCoinAPIElement {
        return ResponseDetailCoinAPIElement(
            assetID: "USD",
            name: "US Dollar",
            typeIsCrypto: 0,
            dataQuoteStart: "2014-02-24T00:00:00.0000000Z",
            dataQuoteEnd: "2024-02-18T00:00:00.0000000Z",
            dataOrderbookStart: "2014-02-24T17:43:05.0000000Z",
            dataOrderbookEnd: "2023-07-07T00:00:00.0000000Z",
            dataTradeStart: "2010-07-17T00:00:00.0000000Z",
            dataTradeEnd: "2024-02-18T00:00:00.0000000Z",
            dataSymbolsCount: 238628,
            volume1HrsUsd: 37319971908.13,
            volume1DayUsd: 2532712685537.20,
            volume1MthUsd: 10930108044040136.20,
            priceUsd: nil,
            idIcon: "0a4185f2-1a03-4a7c-b866-ba7076d8c73b",
            dataStart: "2010-07-17",
            dataEnd: "2024-02-18"
        )
    }
    
    static func placeholder2() -> ResponseDetailCoinAPIElement {
        return ResponseDetailCoinAPIElement(
            assetID: "BTC",
            name: "Bitcoin",
            typeIsCrypto: 1,
            dataQuoteStart: "2014-02-24T00:00:00.0000000Z",
            dataQuoteEnd: "2024-02-18T00:00:00.0000000Z",
            dataOrderbookStart: "2014-02-24T17:43:05.0000000Z",
            dataOrderbookEnd: "2023-07-07T00:00:00.0000000Z",
            dataTradeStart: "2010-07-17T00:00:00.0000000Z",
            dataTradeEnd: "2024-02-18T00:00:00.0000000Z",
            dataSymbolsCount: 205649,
            volume1HrsUsd: 13100411301781.47,
            volume1DayUsd: 7988477591469013.12,
            volume1MthUsd: 2739297522112550865.83,
            priceUsd: 52062.659194689616989393174776,
            idIcon: "4caf2b16-a017-4e26-a348-2cea69c34cba",
            dataStart: "2010-07-17",
            dataEnd: "2024-02-18"
        )
    }
    
}
