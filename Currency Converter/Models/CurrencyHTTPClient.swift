//
//  CurrencyHTTPClient.swift
//  Currency Converter
//
//  Created by Dmytro Ivanchuk on 07.09.2022.
//

import Foundation
import SwiftyJSON

protocol CurrencyHTTPClientProtocol {
    func fetchMidpointRate(completion completionHandler: @escaping (Result <MiddleRateModel, CurrencyHTTPClientError>) -> Void)
    func fetchBuySellRate(completion completionHandler: @escaping (Result <BuySellRateModel, CurrencyHTTPClientError>) -> Void)
    func fetchMiddleRateHistorical(completion completionHandler: @escaping (Result <MiddleRateHistoricalModel, CurrencyHTTPClientError>) -> Void)
}

// create WeatherManager struct, responsible for fetching current weather data using public API, based on user's coordinates
struct CurrencyHTTPClient: CurrencyHTTPClientProtocol {
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    private let urlSession: URLSession
    private let defaults = UserDefaults.standard
    private let calender = Calendar.current
    
    enum DefaultsKey: String {
        case defaultsMiddleRateKey = "MiddleRateLastRefresh"
        case defaultsBuySellRateKey = "BuySellRateLastRefresh"
        case defaultsMiddleRateHistoricalKey = "MiddleRateHistoricalLastRefresh"
    }

    private func isRefreshRequired(for defaultsKey: DefaultsKey) -> Bool {

        guard let lastRefreshDate = defaults.object(forKey: defaultsKey.rawValue) as? Date else {
            return true
        }
        
        let currentHour = calender.dateComponents([.hour], from: Date()).hour
        let lastRefreshHour = calender.dateComponents([.hour], from: lastRefreshDate).hour

        return currentHour != lastRefreshHour ? true : false
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
    
    private var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.apilayer.com"
        components.path = "/exchangerates_data/latest"
        components.queryItems = [
            URLQueryItem(name: "base", value: "USD")
        ]
        return components.url!
    }
    
    private var urlHistorical: URL {
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
    
    func fetchMidpointRate(completion completionHandler: @escaping (Result <MiddleRateModel, CurrencyHTTPClientError>) -> Void) {
        if isRefreshRequired(for: .defaultsMiddleRateKey) {
        
            var request = URLRequest(url: url, timeoutInterval: Double.infinity)
            request.httpMethod = "GET"
            request.addValue(apiKey, forHTTPHeaderField: "apikey")

            let task = urlSession.dataTask(with: request) { data, response, error in
                guard let jsonData = data else {
                    completionHandler(Result.failure(CurrencyHTTPClientError.urlSessionError))
                    return
                }
                do {
                    let jsonObject = try JSON(data: jsonData)
                    let midpointRateModel = MiddleRateModel(jsonObject: jsonObject)
                    completionHandler(Result.success(midpointRateModel))
                } catch {
                    completionHandler(Result.failure(CurrencyHTTPClientError.parseJSONError))
                }
            }
            task.resume()
            
            defaults.set(Date(), forKey: DefaultsKey.defaultsMiddleRateKey.rawValue)
        } else {
            completionHandler(Result.failure(CurrencyHTTPClientError.dataRefreshError))
        }
    }
    
    func fetchBuySellRate(completion completionHandler: @escaping (Result <BuySellRateModel, CurrencyHTTPClientError>) -> Void) {
        if isRefreshRequired(for: .defaultsBuySellRateKey) {
        
            if let url = URL(string: "https://api.monobank.ua/bank/currency") {

                let task = urlSession.dataTask(with: url) { data, response, error in
                    guard let jsonData = data else {
                        completionHandler(Result.failure(CurrencyHTTPClientError.urlSessionError))
                        return
                    }
                    do {
                        let jsonObject = try JSON(data: jsonData)
                        let buySellRateModel = BuySellRateModel(jsonObject: jsonObject)
                        completionHandler(Result.success(buySellRateModel))
                    } catch {
                        completionHandler(Result.failure(CurrencyHTTPClientError.parseJSONError))
                    }
                }
                task.resume()
                
                defaults.set(Date(), forKey: DefaultsKey.defaultsBuySellRateKey.rawValue)
            }
        } else {
            completionHandler(Result.failure(CurrencyHTTPClientError.dataRefreshError))
        }
    }
    
    func fetchMiddleRateHistorical(completion completionHandler: @escaping (Result <MiddleRateHistoricalModel, CurrencyHTTPClientError>) -> Void) {
        if isRefreshRequired(for: .defaultsMiddleRateHistoricalKey) {
            
            var request = URLRequest(url: urlHistorical, timeoutInterval: Double.infinity)
            request.httpMethod = "GET"
            request.addValue(apiKey, forHTTPHeaderField: "apikey")

            let task = urlSession.dataTask(with: request) { data, response, error in
                guard let jsonData = data else {
                    completionHandler(Result.failure(CurrencyHTTPClientError.urlSessionError))
                    return
                }
                do {
                    let jsonObject = try JSON(data: jsonData)
                    let middleRateHistoricalModel = MiddleRateHistoricalModel(jsonObject: jsonObject)
                    completionHandler(Result.success(middleRateHistoricalModel))
                } catch {
                    completionHandler(Result.failure(CurrencyHTTPClientError.parseJSONError))
                }
            }
            task.resume()
            
            defaults.set(Date(), forKey: DefaultsKey.defaultsMiddleRateHistoricalKey.rawValue)
        } else {
            completionHandler(Result.failure(CurrencyHTTPClientError.dataRefreshError))
        }
    }
}

enum CurrencyHTTPClientError: Error {
    case urlSessionError
    case parseJSONError
    case dataRefreshError
}
