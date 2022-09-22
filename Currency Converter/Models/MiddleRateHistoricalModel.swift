//
//  MiddleRateHistoricalModel.swift
//  Currency Converter
//
//  Created by Dmytro Ivanchuk on 22.09.2022.
//

import Foundation
import SwiftyJSON

struct MiddleRateHistoricalModel {
    let currencyRates: [Currency]
    let dateUpdated: Date
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
        var currencyRates: [Currency] = []
        for (key,subJson):(String, JSON) in jsonObject["rates"] {
            currencyRates.append(Currency(currencyCode: key, baseCurrency: "USD", middleRate: subJson.double, buyRate: nil, sellRate: nil))
        }
        self.currencyRates = currencyRates
        dateUpdated = Date(timeIntervalSince1970: jsonObject["timestamp"].doubleValue)
    }
}
