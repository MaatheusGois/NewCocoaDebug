//
//  UIView+Tests.swift
//  DebugSwift
//
//  Created by Matheus Gois on 14/12/2024.
//

import XCTest
@testable import DebugSwift

final class UIViewTests: XCTestCase {

    func testSimulateButtonTap() {
        // Given
        let view = UIView()
        let expectation = self.expectation(description: "Button tap simulated")

        // When
        view.simulateButtonTap {
            // Then
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testAddTopBorderWithColor() {
        // Given
        let view = UIView()
        let color = UIColor.red
        let thickness: CGFloat = 2.0

        // When
        view.addTopBorderWithColor(color: color, thickness: thickness)

        // Then
        guard let border = view.layer.sublayers?.first else {
            XCTFail("Border layer should be added")
            return
        }
        XCTAssertEqual(border.backgroundColor, color.cgColor, "Border color should match")
        XCTAssertEqual(border.frame.height, thickness, "Border thickness should match")
    }

    func testSwizzleMethods() {
        // Given
        let view = UIView()

        // When
        UIView.swizzleMethods()

        // Then
        XCTAssertNotNil(view, "View should be initialized")
    }
}
