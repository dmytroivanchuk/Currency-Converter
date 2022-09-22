//
//  HTTPClient.swift
//  Currency Converter
//
//  Created by Dmytro Ivanchuk on 07.09.2022.
//

import Foundation
import SwiftyJSON


protocol HTTPClientProtocol {
    func fetchMiddleRate(completion completionHandler: @escaping (Result <MiddleRateModel, HTTPClientError>) -> Void)
    func fetchMiddleRateHistorical(completion completionHandler: @escaping (Result <MiddleRateHistoricalModel, HTTPClientError>) -> Void)
    func fetchBuySellRate(completion completionHandler: @escaping (Result <BuySellRateModel, HTTPClientError>) -> Void)
}


struct HTTPClient: HTTPClientProtocol {
    
    private let urlSession: URLSession
    private let defaults = UserDefaults.standard
    
    enum LastRefreshDateUserDefaultsKeys: String {
        case middleRateLastRefreshDate = "middleRateLastRefreshDate"
        case middleRateHistoricalLastRefreshDate = "middleRateHistoricalLastRefreshDate"
        case buySellRateLastRefreshDate = "buySellRateLastRefreshDate"
    }
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    
    private var apiKey: String {
        var keys: NSDictionary?

        if let path = Bundle.main.path(forResource: "Keys", ofType: "plist") {
            keys = NSDictionary(contentsOfFile: path)
        } else {
            fatalError("Error fetching API keys from Keys.plist")
        }
        
        if let dict = keys {
            return dict["apiKey"] as! String
        } else {
            fatalError("Error fetching API keys from Keys.plist")
        }
    }
    
    private var middleRateURL: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.apilayer.com"
        components.path = "/exchangerates_data/latest"
        components.queryItems = [
            URLQueryItem(name: "base", value: "USD")
        ]
        return components.url!
    }
    
    private var middleRateHistoricalURL: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.apilayer.com"
        components.queryItems = [
            URLQueryItem(name: "base", value: "USD")
        ]
        
        let currentDate = Date()
        let yearBackDate = Calendar.current.date(byAdding: .year, value: -1, to: currentDate)
        if let yearBack = yearBackDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let formattedYearBackDate = dateFormatter.string(from: yearBack)
            components.path = "/exchangerates_data/\(formattedYearBackDate)"
        }
        
        return components.url!
    }
    
    private var buySellRateURL: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.monobank.ua"
        components.path = "/bank/currency"

        return components.url!
    }

    
    private func isRefreshRequired(_ key: LastRefreshDateUserDefaultsKeys) -> Bool {
        guard let lastRefreshDate = defaults.object(forKey: key.rawValue) as? Date else {
            return true
        }
        
        let calendar = Calendar.current
        let currentHour = calendar.dateComponents([.hour], from: Date()).hour
        let lastRefreshHour = calendar.dateComponents([.hour], from: lastRefreshDate).hour

        return currentHour != lastRefreshHour ? true : false
    }
    
    
    func fetchMiddleRate(completion completionHandler: @escaping (Result <MiddleRateModel, HTTPClientError>) -> Void) {
        if isRefreshRequired(.middleRateLastRefreshDate) {

            var request = URLRequest(url: middleRateURL, timeoutInterval: Double.infinity)
            request.httpMethod = "GET"
            request.addValue(apiKey, forHTTPHeaderField: "apikey")

            let task = urlSession.dataTask(with: request) { data, response, error in
                guard let jsonData = data else {
                    completionHandler(Result.failure(HTTPClientError.urlSessionError))
                    return
                }
                do {
                    let jsonObject = try JSON(data: jsonData)
                    let middleRateModel = MiddleRateModel(jsonObject: jsonObject)
                    completionHandler(Result.success(middleRateModel))
                } catch {
                    completionHandler(Result.failure(HTTPClientError.parseJSONError))
                }
            }
            task.resume()
            defaults.set(Date(), forKey: LastRefreshDateUserDefaultsKeys.middleRateLastRefreshDate.rawValue)
            
        } else {
            completionHandler(Result.failure(HTTPClientError.dataRefreshError))
        }
    }
    
    
    func fetchMiddleRateHistorical(completion completionHandler: @escaping (Result <MiddleRateHistoricalModel, HTTPClientError>) -> Void) {
        if isRefreshRequired(.middleRateHistoricalLastRefreshDate) {
            
            var request = URLRequest(url: middleRateHistoricalURL, timeoutInterval: Double.infinity)
            request.httpMethod = "GET"
            request.addValue(apiKey, forHTTPHeaderField: "apikey")

            let task = urlSession.dataTask(with: request) { data, response, error in
                guard let jsonData = data else {
                    completionHandler(Result.failure(HTTPClientError.urlSessionError))
                    return
                }
                do {
                    let jsonObject = try JSON(data: jsonData)
                    let middleRateHistoricalModel = MiddleRateHistoricalModel(jsonObject: jsonObject)
                    completionHandler(Result.success(middleRateHistoricalModel))
                } catch {
                    completionHandler(Result.failure(HTTPClientError.parseJSONError))
                }
            }
            task.resume()
            defaults.set(Date(), forKey: LastRefreshDateUserDefaultsKeys.middleRateHistoricalLastRefreshDate.rawValue)
            
        } else {
            completionHandler(Result.failure(HTTPClientError.dataRefreshError))
        }
    }
    
    
    func fetchBuySellRate(completion completionHandler: @escaping (Result <BuySellRateModel, HTTPClientError>) -> Void) {
        if isRefreshRequired(.buySellRateLastRefreshDate) {
        
            let task = urlSession.dataTask(with: buySellRateURL) { data, response, error in
                guard let jsonData = data else {
                    completionHandler(Result.failure(HTTPClientError.urlSessionError))
                    return
                }
                do {
                    let jsonObject = try JSON(data: jsonData)
                    let buySellRateModel = BuySellRateModel(jsonObject: jsonObject)
                    completionHandler(Result.success(buySellRateModel))
                } catch {
                    completionHandler(Result.failure(HTTPClientError.parseJSONError))
                }
            }
            task.resume()
            defaults.set(Date(), forKey: LastRefreshDateUserDefaultsKeys.buySellRateLastRefreshDate.rawValue)
            
        } else {
            completionHandler(Result.failure(HTTPClientError.dataRefreshError))
        }
    }
}

enum HTTPClientError: Error {
    case urlSessionError
    case parseJSONError
    case dataRefreshError
}
