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
    
    func calculateRate(rate: Float, value: Float) -> (Float) {
        return value * rate
    }
    
    func enterValue(from: String, to: String, value: Float, setValue: @escaping (Float) -> ()) {
        self.dateRates.getRate(from: from, to: to) { countries, errorResult  in
            DispatchQueue.main.async {
                switch errorResult {
                case .success:
                    if countries != nil {
                        let rate = countries!.first { $0.convertCountries == "\(from)_\(to)" }
                        let calculateResult: Float = self.calculateRate(rate: rate?.rate ?? 0, value: value)
                        setValue(calculateResult)
                    }
                case .failure(let error):
                    self.viewInputDelegate?.showAlert(with: "Ошибка", and: error.localizedDescription)
                }
                
            }
        }
    }
}

extension Presenter: ViewOutputDelegate {
    
    
    func getData() {
        dataCountries.getData() { countries, error  in
            DispatchQueue.main.async {
                switch error {
                case .success:
                    self.viewInputDelegate?.setupData(data: countries!)
                    self.viewInputDelegate?.setDefaultCountries(from: "RUB", to: "USD")
                    self.viewInputDelegate?.setFromValueTextField(value: 1)
                    self.enterFromValue()
                    self.chenageCurrentCounries()
                case .failure(let error):
                    self.viewInputDelegate?.showAlert(with: "Ошибка", and: error.localizedDescription)
                }
            }
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
    
    func chenageCurrentCounries()  {
        let _fromCountry = self.viewInputDelegate?.getFromCountry() ?? ""
        let _toCountry = self.viewInputDelegate?.getToCountry() ?? ""
        
        let _from = self.viewInputDelegate?.getCountriesForCurrencyExchange().from
        let _to = self.viewInputDelegate?.getCountriesForCurrencyExchange().to
        
        dateRates.getRate(from: _from ?? "", to: _to ?? "") { countries, errorResult  in
            switch errorResult {
            case .success:
                let _rate = countries![1].rate
                let boldText = "\(_rate) \(_toCountry)"
                let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]
                let attributedString = NSMutableAttributedString(string:boldText, attributes:attrs)
                
                let normalString = NSMutableAttributedString(string: "1 \(_fromCountry)\n")
                normalString.append(attributedString)
                DispatchQueue.main.async {
                    self.viewInputDelegate?.setCurrentRateLabel(text: normalString)
                }
            case .failure(let error):
                self.viewInputDelegate?.showAlert(with: "Ошибка", and: error.localizedDescription)
            }
        }
    }
    
}

