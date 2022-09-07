//
//  MockCurrencyHTTPClient.swift
//  Currency Converter
//
//  Created by Dmytro Ivanchuk on 07.09.2022.
//

import Foundation

// create MockCurrencyHTTPClient class, responsible for mocking default http client for UI tests
class MockCurrencyHTTPClient: CurrencyHTTPClientProtocol {
    
    func fetchRate(completion completionHandler: @escaping (Result<CurrencyModel, CurrencyHTTPClientError>) -> Void) {
        // generate data representation of valid .json file
        guard let filePathString = Bundle(for: type(of: self)).path(forResource: "latestRateAPIResponseExample", ofType: "json") else {
            completionHandler(Result.failure(CurrencyHTTPClientError.parseJSONError))
            return
        }
        guard let json = try? String(contentsOfFile: filePathString, encoding: .utf8) else {
            completionHandler(Result.failure(CurrencyHTTPClientError.parseJSONError))
            return
        }

        // decode data from valid .json file
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CurrencyData.self, from: json.data(using: .utf8)!)
            let currencyModel = CurrencyModel(currencyData: decodedData)
            completionHandler(Result.success(currencyModel))
        } catch {
            completionHandler(Result.failure(CurrencyHTTPClientError.parseJSONError))
        }
    }
}
