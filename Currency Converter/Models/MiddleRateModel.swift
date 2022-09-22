//
//  MiddleRateModel.swift
//  Currency Converter
//
//  Created by Dmytro Ivanchuk on 16.09.2022.
//

import Foundation
import SwiftyJSON

struct MiddleRateModel {
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
        var currencies: [Currency] = []
        for (key,subJson):(String, JSON) in jsonObject["rates"] {
            currencies.append(Currency(currencyCode: key, baseCurrency: "USD", middleRate: subJson.double, buyRate: nil, sellRate: nil))
        }
        self.currencies = currencies
        dateUpdated = Date(timeIntervalSince1970: jsonObject["timestamp"].doubleValue)
    }
}
