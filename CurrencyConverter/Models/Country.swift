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
    
    private let apiUrl = "https://free.currconv.com/api/v7/currencies?apiKey=" + (apiKey ?? "")
    
    private var cachedCountries: [Country] = []
    
    func getData(_ onResultLoaded: @escaping (_ countries: [Country]) -> Void) {
        loadData(onResultLoaded)
    }
    
    private func loadData(_ onResultLoaded: @escaping (_ countries: [Country]) -> Void) {
        if !cachedCountries.isEmpty {
            onResultLoaded(cachedCountries)
        } else {
            let url = URL(string: apiUrl)!
            let task = URLSession.shared.dataTask(with: url) { [self] (data, response, error) in
                parseJson(data, onResultLoaded)
            }
            task.resume()
        }
    }
    
    private func parseJson(_ data: Data?, _ onResultLoaded: (_ countries: [Country]) -> Void) {
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
}

