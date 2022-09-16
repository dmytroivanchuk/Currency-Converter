//
//  BuySellRateModel.swift
//  Currency Converter
//
//  Created by Dmytro Ivanchuk on 16.09.2022.
//

import SwiftyJSON

struct BuySellRateModel {
    let currencyRates: [CurrencyRate]
    var currencySections: [CurrencySection] {
        var currencyCodeArray: [String] = []
        for currencyRate in currencyRates {
            currencyCodeArray.append(currencyRate.currencyString)
        }
        let groupedDictionary = Dictionary(grouping: currencyCodeArray, by: { String($0.first!) })
        let dictionaryKeys = groupedDictionary.keys.sorted()
        let currencySections = dictionaryKeys.map { CurrencySection(title: $0, currencyStrings: groupedDictionary[$0]!.sorted()) }
        return currencySections
    }
    
    init(jsonObject: JSON) {
        currencyRates = [
            CurrencyRate(currencyCode: "UAH", baseCurrency: "EUR", rateMidpoint: nil, rateBuy: jsonObject[1]["rateBuy"].double, rateSell: jsonObject[1]["rateSell"].double),
            CurrencyRate(currencyCode: "USD", baseCurrency: "EUR", rateMidpoint: nil, rateBuy: jsonObject[2]["rateBuy"].double, rateSell: jsonObject[2]["rateSell"].double),
            CurrencyRate(currencyCode: "EUR", baseCurrency: "EUR", rateMidpoint: nil, rateBuy: 1.0, rateSell: 1.0)
        ]
    }
}
