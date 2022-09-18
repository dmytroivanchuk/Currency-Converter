//
//  MidpointRateModel.swift
//  Currency Converter
//
//  Created by Dmytro Ivanchuk on 16.09.2022.
//

import SwiftyJSON

struct MidpointRateModel {
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
        var currencyRates: [CurrencyRate] = []
        for (key,subJson):(String, JSON) in jsonObject["rates"] {
            currencyRates.append(CurrencyRate(currencyCode: key, baseCurrency: "USD", rateMidpoint: subJson.double, rateBuy: nil, rateSell: nil))
        }
        self.currencyRates = currencyRates
    }
}
