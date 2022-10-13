//
//  MiddleRateCurrencyDateHistoricalData.swift
//  Currency Converter
//
//  Created by Dmytro Ivanchuk on 22.09.2022.
//

import Foundation
import RealmSwift

class MiddleRateCurrencyDateHistoricalData: Object {
    @Persisted var dateUpdated: Date
    
    convenience init(dateUpdated: Date) {
        self.init()
        self.dateUpdated = dateUpdated
    }
}
