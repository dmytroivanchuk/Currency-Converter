//
//  MiddleRateCurrencyData.swift
//  Currency Converter
//
//  Created by Dmytro Ivanchuk on 19.09.2022.
//

import RealmSwift

class MiddleRateCurrencyData: Object {
    @Persisted var currencyCode: String
    @Persisted var baseCurrency: String
    @Persisted var middleRate: Double?
    @Persisted var buyRate: Double?
    @Persisted var sellRate: Double?
    @Persisted var currencyString: String
    
    convenience init(currencyCode: String, baseCurrency: String, middleRate: Double?, buyRate: Double?, sellRate: Double?, currencyString: String) {
        self.init()
        self.currencyCode = currencyCode
        self.baseCurrency = baseCurrency
        self.middleRate = middleRate
        self.buyRate = buyRate
        self.sellRate = sellRate
        self.currencyString = currencyString
   }
}
