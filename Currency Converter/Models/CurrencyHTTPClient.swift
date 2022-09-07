//
//  CurrencyHTTPClient.swift
//  Currency Converter
//
//  Created by Dmytro Ivanchuk on 07.09.2022.
//

import Foundation

protocol CurrencyHTTPClientProtocol {
    func fetchRate(completion completionHandler: @escaping (Result<CurrencyModel, CurrencyHTTPClientError>) -> Void)
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
    
    func fetchRate(completion completionHandler: @escaping (Result<CurrencyModel, CurrencyHTTPClientError>) -> Void) {
        let url = "https://api.apilayer.com/exchangerates_data/latest?symbols={symbols}&base={USD}"
        var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        request.addValue(apiKey, forHTTPHeaderField: "apikey")

        let task = urlSession.dataTask(with: request) { data, response, error in
            guard let currencyData = data else {
                completionHandler(Result.failure(CurrencyHTTPClientError.urlSessionError))
                return
            }
            
            guard let currencyModel = parseJSON(currencyData) else {
                completionHandler(Result.failure(CurrencyHTTPClientError.parseJSONError))
                return
            }
            
            completionHandler(Result.success(currencyModel))
        }

        task.resume()
    }
    
    private func parseJSON(_ currencyData: Data) -> CurrencyModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CurrencyData.self, from: currencyData)
            let currencyModel = CurrencyModel(currencyData: decodedData)
            return currencyModel
        } catch {
            return nil
        }
    }
}

enum CurrencyHTTPClientError: Error {
    case urlSessionError
    case parseJSONError
}
