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
    
    
    private let apiUrl = "https://free.currconv.com/api/v7/currencies?apiKey=\(Presenter.apiKey ?? "")"
    
    private var cachedCountries: [Country] = []
    
    func getData(_ onResultLoaded: @escaping (_ countries: [Country]?, ErrorResult) -> Void) {
        if !cachedCountries.isEmpty {
            onResultLoaded(cachedCountries, ErrorResult.success)
        } else {
            loadData(onResultLoaded)
        }
    }
    
    private func loadData(_ onResultLoaded: @escaping (_ countries: [Country]?, ErrorResult) -> Void) {
        guard let url = URL(string: apiUrl) else {
            onResultLoaded(nil, .failure(LoadError.emptyURL))
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [self] (data, response, error) in
            guard let data = data, error == nil else {
                onResultLoaded(nil, .failure(error!))
                return
            }
            parseJsonCountry(data, onResultLoaded)
        }
        task.resume()
    }
    
    private func parseJsonCountry(_ data: Data?, _ onResultLoaded: (_ countries: [Country]?, ErrorResult) -> Void) {
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
            if countries.isEmpty {
                onResultLoaded(nil, .failure(LoadError.invalidJSON))
                return
            }
            cachedCountries = countries
            onResultLoaded(countries, ErrorResult.success)
        }
    }
}

