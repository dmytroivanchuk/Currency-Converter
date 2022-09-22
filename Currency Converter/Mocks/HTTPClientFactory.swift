//
//  HTTPClientFactory.swift
//  Currency Converter
//
//  Created by Dmytro Ivanchuk on 07.09.2022.
//

class HTTPClientFactory {
    
    static func returnHTTPClient(forEnvironment environment: String?) -> HTTPClientProtocol {
        environment == "UITEST" ? MockHTTPClient() : HTTPClient()
    }
}
