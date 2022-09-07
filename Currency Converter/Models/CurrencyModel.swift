//
//  CurrencyModel.swift
//  Currency Converter
//
//  Created by Dmytro Ivanchuk on 07.09.2022.
//

import Foundation

struct CurrencyModel {
    init(currencyData: CurrencyData) {
        rates = currencyData.rates
        timestamp = currencyData.timestamp
    }
    
    let timestamp: TimeInterval
    var rates: Rates
    
    var sections: [Section] {
        let groupedDictionary = Dictionary(grouping: rates.allProperties(), by: {String($0.prefix(1))})
        print(groupedDictionary)
        // get the keys and sort them
        let keys = groupedDictionary.keys.sorted()
        print(keys)
        // map the sorted keys to a struct
        let sections = keys.map{ Section(letter: $0, names: groupedDictionary[$0]!.sorted()) }
        return sections
    }
}

struct Section {
    let letter : String
    let names : [String]
}




protocol Loopable {
    func allProperties() -> [String]
}

extension Loopable {
    func allProperties() -> [String] {
        return props(obj: self)
    }
    
    private func props(obj: Any, prefix: String = "") -> [String] {
        let mirror = Mirror(reflecting: obj)
        var result: [String] = []
        for (prop, val) in mirror.children {
            guard var prop = prop else { continue }
   
            // handle the prefix
            if !prefix.isEmpty {
                prop = prefix + prop
                prop = prop.replacingOccurrences(of: ".some", with: "")
            }
   
            if let _ = val as? Loopable {
                let subResult = props(obj: val, prefix: "\(prop).")
                subResult.isEmpty ? result.append(prop) : result.append(contentsOf: subResult)
            } else {
                result.append(prop)
            }
        }
        return result
    }
}
