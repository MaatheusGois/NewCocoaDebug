//
//  LocalizationManager.swift
//  DebugSwift
//
//  Created by Matheus Gois on 19/12/23.
//

import Foundation

class LocalizationManager {
    static let shared = LocalizationManager()
    private init() {}

    private let supportedLanguages = ["pt_BR", "en"]
    private var locale: Locale = .current

    var currentLanguage: String {
        if locale.languageCode?.contains("pt") == true {
            return supportedLanguages[0]
        }
        return supportedLanguages[1]
    }

    private var bundle: Bundle?

    func setLocale(_ locale: Locale) {
        self.locale = locale
        loadBundle()
    }

    func localizedString(_ key: String, _ args: CVarArg...) -> String {
        guard let format = bundle?.localizedString(forKey: key, value: nil, table: nil) else {
            return key
        }
        return String(format: format, locale: Locale.current, arguments: args)
    }

    func loadBundle() {
        guard
            let path = Bundle.module.path(
                forResource: currentLanguage,
                ofType: "lproj"
            ),
            let bundle = Bundle(path: path)
        else {
            self.bundle = Bundle.module
            return
        }
        self.bundle = bundle
    }
}

extension String {
    func localized(_ args: CVarArg...) -> String {
        LocalizationManager.shared.localizedString(self, args)
    }
}
