//
//  BuySellRateModel.swift
//  Currency Converter
//
//  Created by Dmytro Ivanchuk on 16.09.2022.
//

import Foundation
import SwiftyJSON

struct BuySellRateModel {
    let currencies: [Currency]
    let dateUpdated: Date
    var currencySections: [CurrencySection] {
        var currencyCodeArray: [String] = []
        for currency in currencies {
            currencyCodeArray.append(currency.currencyString)
        }
        let groupedDictionary = Dictionary(grouping: currencyCodeArray, by: { String($0.first!) })
        let dictionaryKeys = groupedDictionary.keys.sorted()
        let currencySections = dictionaryKeys.map { CurrencySection(title: $0, currencyStrings: groupedDictionary[$0]!.sorted()) }
        return currencySections
    }
    
    init(jsonObject: JSON) {
        currencies = [
            Currency(currencyCode: "UAH", baseCurrency: "EUR", middleRate: nil, buyRate: jsonObject[1]["rateBuy"].double, sellRate: jsonObject[1]["rateSell"].double),
            Currency(currencyCode: "USD", baseCurrency: "EUR", middleRate: nil, buyRate: jsonObject[2]["rateBuy"].double, sellRate: jsonObject[2]["rateSell"].double),
            Currency(currencyCode: "EUR", baseCurrency: "EUR", middleRate: nil, buyRate: 1.0, sellRate: 1.0)
        ]
        dateUpdated = Date(timeIntervalSince1970: jsonObject[1]["date"].doubleValue)
    }
}
