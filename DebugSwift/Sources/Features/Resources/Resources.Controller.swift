//
//  Resources.Controller.swift
//  DebugSwift
//
//  Created by Matheus Gois on 14/12/23.
//  Copyright © 2023 apple. All rights reserved.
//

import UIKit

final class ResourcesViewController: BaseController, MainFeatureType {
    private enum Item: CaseIterable {
        case fileManager
        case userDefaults
        case keychain
        case coreData
        case httpCookies

        var localized: String {
            switch self {
            case .fileManager:
                "files-title".localized()
            case .userDefaults:
                "user-defaults".localized()
            case .keychain:
                "keychain".localized()
            case .coreData:
                ""
            case .httpCookies:
                "httpcookies".localized()
            }
        }
    }

    var controllerType: DebugSwiftFeature { .resources }

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = Theme.shared.backgroundColor
        tableView.separatorColor = .darkGray

        return tableView
    }()

    private let items: [Item] = [
        .fileManager,
        .userDefaults,
        .keychain,
        .httpCookies
    ]

    override init() {
        super.init()
        setupTabBar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTable()
    }

    func setupTable() {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: .cell
        )

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func setupTabBar() {
        title = "resources-title".localized()
        tabBarItem = UITabBarItem(
            title: title,
            image: .named("filemenu.and.selection"),
            tag: 2
        )
    }
}

extension ResourcesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: .cell,
            for: indexPath
        )
        cell.setup(title: items[indexPath.row].localized)
        return cell
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        80.0
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        var controller: UIViewController?
        switch items[indexPath.row] {
        case .fileManager:
            // Handle "File" selection
            controller = ResourcesFilesViewController()
        case .userDefaults:
            let viewModel = ResourcesUserDefaultsViewModel()
            controller = ResourcesGenericController(viewModel: viewModel)
        case .keychain:
            let viewModel = ResourcesKeychainViewModel()
            controller = ResourcesGenericController(viewModel: viewModel)
        case .coreData:
            // Handle "CoreData" selection
            showAlert(with: "TODO")

        case .httpCookies:
            let viewModel = ResourcesHTTPCookiesViewModel()
            controller = ResourcesGenericController(viewModel: viewModel)
        }
        if let controller {
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
