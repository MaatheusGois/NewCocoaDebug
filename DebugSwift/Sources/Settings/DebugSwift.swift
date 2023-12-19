//
//  DebugSwift.swift
//  DebugSwift
//
//  Created by Matheus Gois on 16/12/23.
//

import UIKit
import CoreLocation

public enum DebugSwift {
    public static func setup() {
        UIView.swizzleMethods()
        UIWindow.db_swizzleMethods()
        URLSessionConfiguration.swizzleMethods()
        CLLocationManager.swizzleMethods()
        LogIntercepter.shared.start()

        LocalizationManager.shared.loadBundle()
        NetworkHelper.shared.enable()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            FloatViewManager.setup(TabBarController())
        }

        LaunchTimeTracker.measureAppStartUpTime()
    }

    public static func show() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            FloatViewManager.show()
        }
    }

    public static func hide() {
        FloatViewManager.remove()
    }
}

extension DebugSwift {
    public enum Network {
        public static var ignoredURLs = [String]()
        public static var onlyURLs = [String]()
    }

    public enum App {
        public static var customInfo: (() -> [CustomData])?
    }

    public enum Console {
        public static var ignoredLogs = [String]()
        public static var onlyLogs = [String]()
    }

    public enum Debugger {
        /// Enable debug logs, default is `true`
        public static var enable: Bool = true
    }
}
