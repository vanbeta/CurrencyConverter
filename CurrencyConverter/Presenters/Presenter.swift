//
//  Presenter.swift
//  CurrencyConverter
//
//  Created by Ivan Poderegin on 24.01.2022.
//

import Foundation
import UIKit

class Presenter {
    
    
    weak private var viewInputDelegate: ViewInputDelegate?
    var dataCountries = Countries()
    var dateRates = Rates()
    
    var allCountries: [Country] = []
    
    var currentRate: [Rate] = [] {
        willSet {
            viewInputDelegate?.setCurrentRateLabel(text: self.viewInputDelegate?.getFromCountry() ?? "")
        }
    }
    
    static var apiKey: String? {
        return Bundle.main.object(forInfoDictionaryKey: "apiKey") as? String
    }
    
    func setViewInputDelegate(viewInputDelegate: ViewInputDelegate?) {
         self.viewInputDelegate = viewInputDelegate
     }
    
    func calculateRate(rate: Float, value: Float) -> (Float) {
        return value * rate
    }
    
    func enterValue(from: String, to: String, value: Float, setValue: @escaping (Float) -> ()) {
        self.dateRates.getRate(from: from, to: to) { countries in
            DispatchQueue.main.async {
                let rate = countries.first { $0.convertCountries == "\(from)_\(to)" }
                let calculateResult: Float = self.calculateRate(rate: rate?.rate ?? 0, value: value)
                setValue(calculateResult)
                
                self.currentRate = self.dateRates.getCurrentRate() // !!!
            }
        }
    }
}

extension Presenter: ViewOutputDelegate {
    
    
    func getData() {
        dataCountries.getData() { countries in
            self.viewInputDelegate?.setupData(data: countries)
            
            if !countries.isEmpty {
                DispatchQueue.main.async {
                    self.viewInputDelegate?.setDefaultCountries(from: "RUB", to: "USD")
                    self.viewInputDelegate?.setFromValueTextField(value: 1)
                    self.enterFromValue()
                }
            }
            self.allCountries = countries
        }
    }
    
    func enterFromValue() {
        let counries = self.viewInputDelegate?.getCountriesForCurrencyExchange()
        guard !(counries!.from.isEmpty || counries!.to.isEmpty) else { return }
        
        self.enterValue(from: counries!.from,
                        to:  counries!.to,
                        value: Float(self.viewInputDelegate?.getFromValueTextField() ?? "") ?? 0,
                        setValue: self.viewInputDelegate!.setToValueTextField)
    }
    
    func enterToVaue() {
        let counries = self.viewInputDelegate?.getCountriesForCurrencyExchange()
        guard !(counries!.from.isEmpty || counries!.to.isEmpty) else { return }

        self.enterValue(from: counries!.to,
                        to: counries!.from,
                        value: Float(self.viewInputDelegate?.getToValueTextField() ?? "") ?? 0,
                        setValue: self.viewInputDelegate!.setFromValueTextField)
    }
}

