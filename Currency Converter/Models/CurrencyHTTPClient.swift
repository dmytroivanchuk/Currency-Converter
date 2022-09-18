//
//  CurrencyHTTPClient.swift
//  Currency Converter
//
//  Created by Dmytro Ivanchuk on 07.09.2022.
//

import Foundation
import SwiftyJSON

protocol CurrencyHTTPClientProtocol {
    func fetchMidpointRate(completion completionHandler: @escaping (Result <MidpointRateModel, CurrencyHTTPClientError>) -> Void)
    func fetchBuySellRate(completion completionHandler: @escaping (Result <BuySellRateModel, CurrencyHTTPClientError>) -> Void)
}

// create WeatherManager struct, responsible for fetching current weather data using public API, based on user's coordinates
struct CurrencyHTTPClient: CurrencyHTTPClientProtocol {
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    private let urlSession: URLSession
    
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
    
    func fetchMidpointRate(completion completionHandler: @escaping (Result <MidpointRateModel, CurrencyHTTPClientError>) -> Void) {
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
                let midpointRateModel = MidpointRateModel(jsonObject: jsonObject)
                completionHandler(Result.success(midpointRateModel))
            } catch {
                completionHandler(Result.failure(CurrencyHTTPClientError.parseJSONError))
            }
        }

        task.resume()
    }
    
    func fetchBuySellRate(completion completionHandler: @escaping (Result <BuySellRateModel, CurrencyHTTPClientError>) -> Void) {
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
        }
    }
}

enum CurrencyHTTPClientError: Error {
    case urlSessionError
    case parseJSONError
}
