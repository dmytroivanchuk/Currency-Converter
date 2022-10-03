//
//  MockHTTPClient.swift
//  Currency Converter
//
//  Created by Dmytro Ivanchuk on 07.09.2022.
//

import Foundation
import SwiftyJSON


class MockHTTPClient: HTTPClientProtocol {
    
    private let defaults = UserDefaults.standard
    
    enum MockLastRefreshDateUserDefaultsKeys: String {
        case mockMiddleRateLastRefreshDate = "mockMiddleRateLastRefreshDate"
        case mockMiddleRateHistoricalLastRefreshDate = "mockMiddleRateHistoricalLastRefreshDate"
        case mockBuySellRateLastRefreshDate = "mockBuySellRateLastRefreshDate"
        
    }
    

    private func isRefreshRequired(_ key: MockLastRefreshDateUserDefaultsKeys) -> Bool {
        guard let lastRefreshDate = defaults.object(forKey: key.rawValue) as? Date else {
            return true
        }
        
        let calendar = Calendar.current
        if key == .mockMiddleRateHistoricalLastRefreshDate {
            let currentDay = calendar.dateComponents([.day], from: Date()).day
            let lastRefreshDay = calendar.dateComponents([.day], from: lastRefreshDate).day

            return currentDay != lastRefreshDay ? true : false
        } else {
            let currentHour = calendar.dateComponents([.hour], from: Date()).hour
            let lastRefreshHour = calendar.dateComponents([.hour], from: lastRefreshDate).hour

            return currentHour != lastRefreshHour ? true : false
        }
    }
    
    
    func fetchMiddleRate(completion completionHandler: @escaping (Result <MiddleRateModel, HTTPClientError>) -> Void) {
        if isRefreshRequired(.mockMiddleRateLastRefreshDate) {
            if let jsonPath = Bundle.main.url(forResource: "middleRateAPIResponseExample", withExtension: "json") {
                do {
                    let jsonData = try Data(contentsOf: jsonPath)
                    let jsonObject = try JSON(data: jsonData)
                    let middleRateModel = MiddleRateModel(jsonObject: jsonObject)
                    completionHandler(Result.success(middleRateModel))
                } catch {
                    completionHandler(Result.failure(HTTPClientError.parseJSONError))
                }
            } else {
                completionHandler(Result.failure(HTTPClientError.parseJSONError))
            }
            defaults.set(Date(), forKey: MockLastRefreshDateUserDefaultsKeys.mockMiddleRateLastRefreshDate.rawValue)
        
        } else {
            completionHandler(Result.failure(HTTPClientError.dataRefreshError))
        }
    }
    
    
    func fetchMiddleRateHistorical(completion completionHandler: @escaping (Result <MiddleRateHistoricalModel, HTTPClientError>) -> Void) {
        if isRefreshRequired(.mockMiddleRateHistoricalLastRefreshDate) {
            if let jsonPath = Bundle.main.url(forResource: "middleRateHistoricalAPIResponseExample", withExtension: "json") {
                do {
                    let jsonData = try Data(contentsOf: jsonPath)
                    let jsonObject = try JSON(data: jsonData)
                    let middleRateHistoricalModel = MiddleRateHistoricalModel(jsonObject: jsonObject)
                    completionHandler(Result.success(middleRateHistoricalModel))
                } catch {
                    completionHandler(Result.failure(HTTPClientError.parseJSONError))
                }
            } else {
                completionHandler(Result.failure(HTTPClientError.parseJSONError))
            }
            defaults.set(Date(), forKey: MockLastRefreshDateUserDefaultsKeys.mockMiddleRateHistoricalLastRefreshDate.rawValue)
            
        } else {
            completionHandler(Result.failure(HTTPClientError.dataRefreshError))
        }
    }
    
    
    func fetchBuySellRate(completion completionHandler: @escaping (Result <BuySellRateModel, HTTPClientError>) -> Void) {
        if isRefreshRequired(.mockBuySellRateLastRefreshDate) {
            if let jsonPath = Bundle.main.url(forResource: "buySellRateAPIResponseExample", withExtension: "json") {
                do {
                    let jsonData = try Data(contentsOf: jsonPath)
                    let jsonObject = try JSON(data: jsonData)
                    let buySellRateModel = BuySellRateModel(jsonObject: jsonObject)
                    completionHandler(Result.success(buySellRateModel))
                } catch {
                    completionHandler(Result.failure(HTTPClientError.parseJSONError))
                }
            } else {
                completionHandler(Result.failure(HTTPClientError.parseJSONError))
            }
            defaults.set(Date(), forKey: MockLastRefreshDateUserDefaultsKeys.mockBuySellRateLastRefreshDate.rawValue)
            
        } else {
            completionHandler(Result.failure(HTTPClientError.dataRefreshError))
        }
    }
}
