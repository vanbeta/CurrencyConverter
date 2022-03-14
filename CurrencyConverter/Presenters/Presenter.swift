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
    
    static var apiKey: String? {
        return Bundle.main.object(forInfoDictionaryKey: "apiKey") as? String
    }
    
    func setViewInputDelegate(viewInputDelegate: ViewInputDelegate?) {
         self.viewInputDelegate = viewInputDelegate
     }
    
    func calculateRate(rate: Double, value: Double) -> (Double) {
        return value * rate
    }
    
    func enterValue(from: String, to: String, value: Double, setValue: @escaping (Double) -> ()) {
        self.dateRates.getRate(from: from, to: to) { countries in
            DispatchQueue.main.async {
                let rate = countries.first { $0.convertCountries == "\(from)_\(to)" }
                let calculateResult: Double = self.calculateRate(rate: rate?.rate ?? 0, value: value)
                setValue(calculateResult)
            }
        }
    }
}

extension Presenter: ViewOutputDelegate {
    
    
    func getData() {
        dataCountries.getData() { countries in
            self.viewInputDelegate?.setupData(data: countries)
            DispatchQueue.main.async {
                self.viewInputDelegate?.setDefaultCountries(from: "RUB", to: "USD")
            }
        }
    }
    
    func enterFromValue() {
        let counries = self.viewInputDelegate?.getCountriesForCurrencyExchange()
        guard !(counries!.from.isEmpty || counries!.to.isEmpty) else { return }
        
        self.enterValue(from: counries!.from,
                        to:  counries!.to,
                        value: Double(self.viewInputDelegate?.getFromValueTextField() ?? "") ?? 0,
                        setValue: self.viewInputDelegate!.setToValueTextField(value:))
    }
    
    func enterToVaue() {
        let counries = self.viewInputDelegate?.getCountriesForCurrencyExchange()
        guard !(counries!.from.isEmpty || counries!.to.isEmpty) else { return }
        
        self.enterValue(from: counries!.to,
                        to: counries!.from,
                        value: Double(self.viewInputDelegate?.getToValueTextField() ?? "") ?? 0,
                        setValue: self.viewInputDelegate!.setFromValueTextField)
    }
}

