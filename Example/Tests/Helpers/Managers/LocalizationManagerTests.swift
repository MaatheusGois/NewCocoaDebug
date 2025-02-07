//
//  LocalizationManagerTests.swift
//  DebugSwift
//
//  Created by Matheus Gois on 15/12/2024.
//

@testable import DebugSwift
import XCTest

final class LocalizationManagerTests: XCTestCase {
    override static func setUp() {
        super.setUp()
        LocalizationManager.shared.loadBundle()
    }

    func testLocalizedStringWithValidKeyEn() {
        // Given
        let key = "size"
        let expectedValue = "Size"

        // When
        let mockLocale = Locale(identifier: "en")
        LocalizationManager.shared.setLocale(mockLocale)
        let localizedString = LocalizationManager.shared.localizedString(key)

        // Then
        XCTAssertEqual(localizedString, expectedValue, "The localized string for key 'size' should be 'Size'")
    }

    func testLocalizedStringWithInvalidKey() {
        // Given
        let key = "invalid_key"

        // When
        let localizedString = LocalizationManager.shared.localizedString(key)

        // Then
        XCTAssertEqual(localizedString, key, "The localized string for an invalid key should return the key itself")
    }
}
