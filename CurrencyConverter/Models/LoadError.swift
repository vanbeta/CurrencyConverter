//
//  LoadError.swift
//  CurrencyConverter
//
//  Created by Ivan Poderegin on 23.03.2022.
//

import Foundation

enum DataResult {
    case success
    case failure(Error)
}

enum LoadError {
    case invalidURL
    case invalidJSON
    case unknownError
}

extension LoadError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("Не правильный URL", comment: "")
        case .invalidJSON:
            return NSLocalizedString("Не удалось распарсить JSON", comment: "")
        case .unknownError:
            return NSLocalizedString("Неизвестная ошибка", comment: "")
        }
    }
}
