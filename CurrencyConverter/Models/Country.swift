//
//  Country.swift
//  CurrencyConverter
//
//  Created by Ivan Poderegin on 25.01.2022.
//

import Foundation

struct Country: Codable {
    var currencyName: String
    var currencySymbol: String
    var id: String
}

class Countries {
    var countries: [Country] = []
    
    func updateCountries() {
//        if let url = URL(string: "https://api.myjson.com/bins/yfua8") {
//           // the url
//        }
//
        let url = URL(string: "https://free.currconv.com/api/v7/currencies?apiKey=***REMOVED***")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            //            guard let data = data else { return }
            //            print(String(data: data, encoding: .utf8)!)
            //
            if let data = data {
                do {
                    let res = try JSONDecoder().decode(Country.self, from: data)
     
                } catch let error {
                    print(error)
                }
            }
        }
        task.resume()
    }
}

