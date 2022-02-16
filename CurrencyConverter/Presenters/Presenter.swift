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
    var data = Countries()
    
    func setViewInputDelegate(viewInputDelegate: ViewInputDelegate?) {
         self.viewInputDelegate = viewInputDelegate
     }
    
    func calculateRate(rate: Double, value: Double) -> (Double) {
        return value * rate
    }
}

extension Presenter: ViewOutputDelegate {
    
    
    func getData() {
        data.getData() { countries in
            self.viewInputDelegate?.setupData(data: countries)
        }
    }
    
    func enterFromValue() {
        let counries = self.viewInputDelegate?.getCountriesForCurrencyExchange()
        guard !(counries!.from.isEmpty || counries!.to.isEmpty) else { return }
        
        self.data.getRate(from: counries!.from, to: counries!.to) { countries in
            DispatchQueue.main.async {
                let rate = countries[counries!.from + "_" + counries!.to] ?? 0
                let calculateResult: Double = self.calculateRate(rate: rate, value: Double(self.viewInputDelegate?.getFromValueTextField() ?? "") ?? 0)
                self.viewInputDelegate?.setToValueTextField(value: calculateResult)
            }
        }
    }
}

