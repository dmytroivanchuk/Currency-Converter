//
//  HTTPClientFactory.swift
//  Currency Converter
//
//  Created by Dmytro Ivanchuk on 07.09.2022.
//

import Foundation

// create HTTPClientFactory class, responsible for assigning the appropriate http client, based on app launch environment. For UI tests assign mock http client, for production assign default http client
class HTTPClientFactory {
    
    static func returnCurrencyHTTPClient(forEnvironment environment: String?) -> CurrencyHTTPClientProtocol {
        environment == "UITEST" ? MockCurrencyHTTPClient() : CurrencyHTTPClient()
    }
}
