//
//  LoadError.swift
//  CurrencyConverter
//
//  Created by Ivan Poderegin on 23.03.2022.
//

import Foundation

enum ErrorResult {
    case success
    case failure(Error)
}

enum LoadError {
    case emptyURL
    case invalidJSON
    case emptyData
    case unknownError
}

extension LoadError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .emptyURL:
            return NSLocalizedString("Пустой URL", comment: "")
        case .invalidJSON:
            return NSLocalizedString("Не удалось распарсить JSON", comment: "")
        case .emptyData:
            return NSLocalizedString("Не удалось загрузить данные", comment: "")
        case .unknownError:
            return NSLocalizedString("Неизвестная ошибка", comment: "")
        }
    }
}
