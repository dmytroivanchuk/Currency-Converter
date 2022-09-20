//
//  BuySellRateCurrencySectionData.swift
//  Currency Converter
//
//  Created by Dmytro Ivanchuk on 19.09.2022.
//

import RealmSwift

class BuySellRateCurrencySectionData: Object {
    @Persisted var title: String
    @Persisted var currencyStrings = List<String>()
    
    convenience init(title: String) {
        self.init()
        self.title = title
    }
}
