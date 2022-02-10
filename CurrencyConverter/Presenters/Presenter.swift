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
}

extension Presenter: ViewOutputDelegate {
    
    
    func getData() {
        data.getData() { countries in
            self.viewInputDelegate?.setupData(data: countries)
        }
    }
    
    func enterFromValue() {
        let counries = self.viewInputDelegate?.getCountriesForCurrencyExchange()
//        guard (counries!.from.isEmpty || counries!.to.isEmpty) else { return } !!!
        
        data.getRate(from: counries!.from, to: counries!.to)
        
//        print(counries.from + " + " + counries.to)
//        self.viewInputDelegate?.getDataForCurrencyExchange()
    }
}

