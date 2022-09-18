//
//  MockCurrencyHTTPClient.swift
//  Currency Converter
//
//  Created by Dmytro Ivanchuk on 07.09.2022.
//

import Foundation
import SwiftyJSON

// create MockCurrencyHTTPClient class, responsible for mocking default http client for UI tests
class MockCurrencyHTTPClient: CurrencyHTTPClientProtocol {
    
    func fetchMidpointRate(completion completionHandler: @escaping (Result <MidpointRateModel, CurrencyHTTPClientError>) -> Void) {
        if let jsonPath = Bundle.main.url(forResource: "midpointRateAPIResponseExample", withExtension: "json") {
            do {
                let jsonData = try Data(contentsOf: jsonPath)
                let jsonObject = try JSON(data: jsonData)
                let midpointRateModel = MidpointRateModel(jsonObject: jsonObject)
                completionHandler(Result.success(midpointRateModel))
            } catch {
                completionHandler(Result.failure(CurrencyHTTPClientError.parseJSONError))
            }
        } else {
            completionHandler(Result.failure(CurrencyHTTPClientError.parseJSONError))
        }
    }
    
    func fetchBuySellRate(completion completionHandler: @escaping (Result <BuySellRateModel, CurrencyHTTPClientError>) -> Void) {
        if let jsonPath = Bundle.main.url(forResource: "buySellRateAPIResponseExample", withExtension: "json") {
            do {
                let jsonData = try Data(contentsOf: jsonPath)
                let jsonObject = try JSON(data: jsonData)
                let buySellRateModel = BuySellRateModel(jsonObject: jsonObject)
                completionHandler(Result.success(buySellRateModel))
            } catch {
                completionHandler(Result.failure(CurrencyHTTPClientError.parseJSONError))
            }
        } else {
            completionHandler(Result.failure(CurrencyHTTPClientError.parseJSONError))
        }
    }
}
