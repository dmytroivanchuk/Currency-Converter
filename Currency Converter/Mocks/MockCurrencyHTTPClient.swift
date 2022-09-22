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
    
    private let defaults = UserDefaults.standard
    private let calender = Calendar.current
    
    enum MockDefaultsKey: String {
        case mockDefaultsMiddleRateKey = "MockMiddleRateLastRefresh"
        case mockDefaultsBuySellRateKey = "MockBuySellRateLastRefresh"
        case mockDefaultsMiddleRateHistoricalKey = "MockMiddleRateHistoricalLastRefresh"
    }

    private func isRefreshRequired(for defaultsKey: MockDefaultsKey) -> Bool {

        guard let lastRefreshDate = defaults.object(forKey: defaultsKey.rawValue) as? Date else {
            return true
        }
        
        let currentHour = calender.dateComponents([.hour], from: Date()).hour
        let lastRefreshHour = calender.dateComponents([.hour], from: lastRefreshDate).hour

        return currentHour != lastRefreshHour ? true : false
    }
    
    
    func fetchMidpointRate(completion completionHandler: @escaping (Result <MiddleRateModel, CurrencyHTTPClientError>) -> Void) {
        
        if isRefreshRequired(for: .mockDefaultsMiddleRateKey) {
            if let jsonPath = Bundle.main.url(forResource: "midpointRateAPIResponseExample", withExtension: "json") {
                do {
                    let jsonData = try Data(contentsOf: jsonPath)
                    let jsonObject = try JSON(data: jsonData)
                    let midpointRateModel = MiddleRateModel(jsonObject: jsonObject)
                    completionHandler(Result.success(midpointRateModel))
                } catch {
                    completionHandler(Result.failure(CurrencyHTTPClientError.parseJSONError))
                }
            } else {
                completionHandler(Result.failure(CurrencyHTTPClientError.parseJSONError))
            }
            defaults.set(Date(), forKey: MockDefaultsKey.mockDefaultsMiddleRateKey.rawValue)
        } else {
            completionHandler(Result.failure(CurrencyHTTPClientError.dataRefreshError))
        }
    }
    
    func fetchBuySellRate(completion completionHandler: @escaping (Result <BuySellRateModel, CurrencyHTTPClientError>) -> Void) {
        if isRefreshRequired(for: .mockDefaultsBuySellRateKey) {
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
            defaults.set(Date(), forKey: MockDefaultsKey.mockDefaultsBuySellRateKey.rawValue)
        } else {
            completionHandler(Result.failure(CurrencyHTTPClientError.dataRefreshError))
        }
    }
    
    func fetchMiddleRateHistorical(completion completionHandler: @escaping (Result <MiddleRateHistoricalModel, CurrencyHTTPClientError>) -> Void) {
        
        if isRefreshRequired(for: .mockDefaultsMiddleRateHistoricalKey) {
            if let jsonPath = Bundle.main.url(forResource: "historicalRateAPIResponseExample", withExtension: "json") {
                do {
                    let jsonData = try Data(contentsOf: jsonPath)
                    let jsonObject = try JSON(data: jsonData)
                    let middleRateHistoricalModel = MiddleRateHistoricalModel(jsonObject: jsonObject)
                    completionHandler(Result.success(middleRateHistoricalModel))
                } catch {
                    completionHandler(Result.failure(CurrencyHTTPClientError.parseJSONError))
                }
            } else {
                completionHandler(Result.failure(CurrencyHTTPClientError.parseJSONError))
            }
            defaults.set(Date(), forKey: MockDefaultsKey.mockDefaultsMiddleRateKey.rawValue)
        } else {
            completionHandler(Result.failure(CurrencyHTTPClientError.dataRefreshError))
        }
    }
}
