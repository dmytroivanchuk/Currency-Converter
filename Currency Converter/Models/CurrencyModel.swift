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
        // map the sorted keys to a struct
        let sections = keys.map{ Section(letter: $0, names: groupedDictionary[$0]!.sorted().map { $0 + " - " + (currencyCodeFullNameDictionary[$0] ?? "") }) }
        return sections
    }
    
    var currencyCodeFullNameDictionary = [
        "AFN" : "Afghani",
        "ALL" : "Lek",
        "DZD" : "Algerian Dinar",
        "USD" : "US Dollar",
        "EUR" : "Euro",
        "AOA" : "Kwanza",
        "XCD" : "East Caribbean Dollar",
        "ARS" : "Argentine Peso",
        "AMD" : "Armenian Dram",
        "AWG" : "Aruban Florin",
        "AUD" : "Australian Dollar",
        "AZN" : "Azerbaijanian Manat",
        "BSD" : "Bahamian Dollar",
        "BHD" : "Bahraini Dinar",
        "BDT" : "Taka",
        "BBD" : "Barbados Dollar",
        "BYN" : "Belarussian Ruble",
        "BZD" : "Belize Dollar",
        "XOF" : "CFA Franc BCEAO",
        "BMD" : "Bermudian Dollar",
        "BTN" : "Ngultrum",
        "INR" : "Indian Rupee",
        "BOB" : "Boliviano",
        "BOV" : "Mvdol",
        "BAM" : "Convertible Mark",
        "BWP" : "Pula",
        "NOK" : "Norwegian Krone",
        "BRL" : "Brazilian Real",
        "BND" : "Brunei Dollar",
        "BGN" : "Bulgarian Lev",
        "BIF" : "Burundi Franc",
        "CVE" : "Cabo Verde Escudo",
        "KHR" : "Riel",
        "XAF" : "CFA Franc BEAC",
        "CAD" : "Canadian Dollar",
        "KYD" : "Cayman Islands Dollar",
        "CLF" : "Unidad de Fomento",
        "CLP" : "Chilean Peso",
        "CNY" : "Yuan Renminbi",
        "COP" : "Colombian Peso",
        "COU" : "Unidad de Valor Real",
        "KMF" : "Comoro Franc",
        "CDF" : "Congolese Franc",
        "NZD" : "New Zealand Dollar",
        "CRC" : "Costa Rican Colon",
        "HRK" : "Kuna",
        "CUC" : "Peso Convertible",
        "CUP" : "Cuban Peso",
        "ANG" : "Netherlands Antillean Guilder",
        "CZK" : "Czech Koruna",
        "DKK" : "Danish Krone",
        "DJF" : "Djibouti Franc",
        "DOP" : "Dominican Peso",
        "EGP" : "Egyptian Pound",
        "SVC" : "El Salvador Colon",
        "ERN" : "Nakfa",
        "ETB" : "Ethiopian Birr",
        "FKP" : "Falkland Islands Pound",
        "FJD" : "Fiji Dollar",
        "XPF" : "CFP Franc",
        "GMD" : "Dalasi",
        "GEL" : "Lari",
        "GHS" : "Ghana Cedi",
        "GIP" : "Gibraltar Pound",
        "GTQ" : "Quetzal",
        "GBP" : "Pound Sterling",
        "GNF" : "Guinea Franc",
        "GYD" : "Guyana Dollar",
        "HTG" : "Gourde",
        "HNL" : "Lempira",
        "HKD" : "Hong Kong Dollar",
        "HUF" : "Forint",
        "ISK" : "Iceland Krona",
        "IDR" : "Rupiah",
        "XDR" : "SDR (Special Drawing Right)",
        "IRR" : "Iranian Rial",
        "IQD" : "Iraqi Dinar",
        "ILS" : "New Israeli Sheqel",
        "JMD" : "Jamaican Dollar",
        "JPY" : "Yen",
        "JOD" : "Jordanian Dinar",
        "KZT" : "Tenge",
        "KES" : "Kenyan Shilling",
        "KPW" : "North Korean Won",
        "KRW" : "Won",
        "KWD" : "Kuwaiti Dinar",
        "KGS" : "Som",
        "LAK" : "Kip",
        "LBP" : "Lebanese Pound",
        "LSL" : "Loti",
        "ZAR" : "Rand",
        "LRD" : "Liberian Dollar",
        "LYD" : "Libyan Dinar",
        "CHF" : "Swiss Franc",
        "MOP" : "Pataca",
        "MGA" : "Malagasy Ariary",
        "MWK" : "Kwacha",
        "MYR" : "Malaysian Ringgit",
        "MVR" : "Rufiyaa",
        "MRU" : "Ouguiya",
        "MUR" : "Mauritius Rupee",
        "XUA" : "ADB Unit of Account",
        "MXN" : "Mexican Peso",
        "MXV" : "Mexican Unidad de Inversion (UDI)",
        "MDL" : "Moldovan Leu",
        "MNT" : "Tugrik",
        "MAD" : "Moroccan Dirham",
        "MZN" : "Mozambique Metical",
        "MMK" : "Kyat",
        "NAD" : "Namibia Dollar",
        "NPR" : "Nepalese Rupee",
        "NIO" : "Cordoba Oro",
        "NGN" : "Naira",
        "OMR" : "Rial Omani",
        "PKR" : "Pakistan Rupee",
        "PAB" : "Balboa",
        "PGK" : "Kina",
        "PYG" : "Guarani",
        "PEN" : "Nuevo Sol",
        "PHP" : "Philippine Peso",
        "PLN" : "Zloty",
        "QAR" : "Qatari Rial",
        "MKD" : "Denar",
        "RON" : "Romanian Leu",
        "RUB" : "Russian Ruble",
        "RWF" : "Rwanda Franc",
        "SHP" : "Saint Helena Pound",
        "WST" : "Tala",
        "STN" : "Dobra",
        "SAR" : "Saudi Riyal",
        "RSD" : "Serbian Dinar",
        "SCR" : "Seychelles Rupee",
        "SLE" : "Leone",
        "SGD" : "Singapore Dollar",
        "XSU" : "Sucre",
        "SBD" : "Solomon Islands Dollar",
        "SOS" : "Somali Shilling",
        "SSP" : "South Sudanese Pound",
        "LKR" : "Sri Lanka Rupee",
        "SDG" : "Sudanese Pound",
        "SRD" : "Surinam Dollar",
        "SZL" : "Lilangeni",
        "SEK" : "Swedish Krona",
        "CHE" : "WIR Euro",
        "CHW" : "WIR Franc",
        "SYP" : "Syrian Pound",
        "TWD" : "New Taiwan Dollar",
        "TJS" : "Somoni",
        "TZS" : "Tanzanian Shilling",
        "THB" : "Baht",
        "TOP" : "Pa’anga",
        "TTD" : "Trinidad and Tobago Dollar",
        "TND" : "Tunisian Dinar",
        "TRY" : "Turkish Lira",
        "TMT" : "Turkmenistan New Manat",
        "UGX" : "Uganda Shilling",
        "UAH" : "Hryvnia",
        "AED" : "UAE Dirham",
        "USN" : "US Dollar (Next day)",
        "UYI" : "Uruguay Peso en Unidades Indexadas (URUIURUI)",
        "UYU" : "Peso Uruguayo",
        "UZS" : "Uzbekistan Sum",
        "VUV" : "Vatu",
        "VEF" : "Bolivar",
        "VED" : "Bolivar",
        "VND" : "Dong",
        "YER" : "Yemeni Rial",
        "ZMW" : "Zambian Kwacha",
        "ZWL" : "Zimbabwe Dollar",
        "BTC" : "Bitcoin",
        "BYR" : "Old Belarusian Ruble",
        "GGP" : "Guernsey Pound",
        "IMP" : "Manx Pound",
        "JEP" : "Jersey Pound",
        "LTL" : "Lithuanian Litas",
        "LVL" : "Latvian Lats",
        "MRO" : "Mauritanian Ouguiya",
        "SLL" : "Sierra Leonean Leone",
        "STD" : "Sao Tome and Principe Dobra",
        "XAG" : "Silver Ounce",
        "XAU" : "Gold Ounce",
        "ZMK" : "Old Zambian Kwacha"
    ]
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
