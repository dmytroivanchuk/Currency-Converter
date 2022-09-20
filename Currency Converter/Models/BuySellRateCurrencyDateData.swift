//
//  BuySellRateCurrencyDateData.swift
//  Currency Converter
//
//  Created by Dmytro Ivanchuk on 20.09.2022.
//

import Foundation
import RealmSwift

class BuySellRateCurrencyDateData: Object {
    @Persisted var dateUpdated: Date
    
    convenience init(dateUpdated: Date) {
        self.init()
        self.dateUpdated = dateUpdated
    }
}
