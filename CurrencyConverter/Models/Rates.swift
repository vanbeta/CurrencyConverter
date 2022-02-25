//
//  Rates.swift
//  CurrencyConverter
//
//  Created by Ivan Poderegin on 17.02.2022.
//

import Foundation

struct Rate {
    
    
    var convertCountries: String
    var rate: Double
}

class Rates {
    
    
    private var cachedRates: [Rate] = []
    
    func getRate(from: String, to: String, _ onResultLoaded: @escaping (_ countries: [Rate]) -> Void) {
        if cachedRates.contains(where: { $0.convertCountries == "\(from) _ \(to)" }) {
            onResultLoaded(cachedRates)
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
    
    func parseJsonRate(_ data: Data?, _ onResultLoaded: @escaping (_ countries: [Rate]) -> Void) {
        if let data = data {
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            if let dictionary = json as? [String: Double] {
                
                var rates: [Rate] = []
                cachedRates.removeAll()
                
                for value in dictionary {
                    let rate = Rate(convertCountries: value.key , rate: value.value)
                    rates.append(rate)
                }
                
                cachedRates = rates
                onResultLoaded(cachedRates)
            }
        }
    }
}
