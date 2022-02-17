//
//  Country.swift
//  CurrencyConverter
//
//  Created by Ivan Poderegin on 25.01.2022.
//

import Foundation

struct Country {
    
    
    var currencyName: String?
    var currencySymbol: String?
    var id: String?
}

class Countries {
    
    
    static var apiKey: String? {
        return Bundle.main.object(forInfoDictionaryKey: "apiKey") as? String
    }
    
    private let apiUrl = "https://free.currconv.com/api/v7/currencies?apiKey=\(apiKey ?? "")"
    
    private var cachedCountries: [Country] = []
    
    private var cachedRate: [String: Double] = [:]
    
    func getData(_ onResultLoaded: @escaping (_ countries: [Country]) -> Void) {
        if !cachedCountries.isEmpty {
            onResultLoaded(cachedCountries)
        } else {
            loadData(onResultLoaded)
        }
    }
    
    private func loadData(_ onResultLoaded: @escaping (_ countries: [Country]) -> Void) {
        guard let url = URL(string: apiUrl) else {
            fatalError("error")
        }
        let task = URLSession.shared.dataTask(with: url) { [self] (data, response, error) in
            guard let data = data, error == nil else { fatalError("error") }
            parseJsonCountry(data, onResultLoaded)
        }
        task.resume()
    }
    
    private func parseJsonCountry(_ data: Data?, _ onResultLoaded: (_ countries: [Country]) -> Void) {
        if let data = data {
            var countries: [Country] = []
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            if let dictionary = json as? [String: Any] {
                if let nestedDictionary = dictionary["results"] as? [String: Any] {
                    for (_, value) in nestedDictionary {
                        if let result = value as? [String: String] {
                            let country = Country(currencyName: result["currencyName"],
                                                  currencySymbol: result["currencySymbol"],
                                                  id: result["id"])
                            countries.append(country)
                        }
                    }
                }
            }
            cachedCountries = countries
            onResultLoaded(countries)
        }
    }
    
    func getRate(from: String, to: String, _ onResultLoaded: @escaping (_ countries: [String: Double]) -> Void) {
        if cachedRate.contains(where: { $0.key == "\(from) _ \(to)" }) {
            onResultLoaded(cachedRate)
        } else {
            guard !from.isEmpty || !to.isEmpty else { return }
                
            let apiUrlRate = "https://free.currconv.com/api/v7/convert?q=\(from)_\(to),\(to)_\(from)&compact=ultra&apiKey=\(Countries.apiKey ?? "")"

            guard let url = URL(string: apiUrlRate) else {
                fatalError("error")
            }

            let task = URLSession.shared.dataTask(with: url) { [self] (data, response, error) in
                guard let data = data, error == nil else { fatalError("error") }
                parseJsonRate(data, onResultLoaded)
            }
            task.resume()
        }
    }
    
    func parseJsonRate(_ data: Data?, _ onResultLoaded: @escaping (_ countries: [String: Double]) -> Void) {
        if let data = data {
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            if let dictionary = json as? [String: Double] {
                cachedRate.removeAll()
                cachedRate = dictionary
                onResultLoaded(cachedRate)
            }
        }
    }
}

