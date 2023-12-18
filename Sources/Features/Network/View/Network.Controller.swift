//
//  Network.Controller.swift
//  DebugSwift
//
//  Created by Matheus Gois on 14/12/23.
//  Copyright © 2023 apple. All rights reserved.
//

import UIKit

class NetworkViewController: BaseController, UISearchBarDelegate {
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .black
        return tableView
    }()

    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search"
        return searchBar
    }()

    private let viewModel = NetworkViewModel()

    override init() {
        super.init()
        setup()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollToBottom()
    }

    func setup() {
        title = "Network"
        tabBarItem = UITabBarItem(
            title: title,
            image: UIImage(named: "network"),
            tag: 0
        )
        view.backgroundColor = .black
        setupKeyboardDismissGesture()
        observers()
    }

    func observers() {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name(rawValue: "reloadHttp_DebugSwift"),
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.reloadHttp(needScrollToEnd: self?.viewModel.reachEnd ?? true)
        }
    }

    func reloadHttp(needScrollToEnd: Bool = false) {
        guard viewModel.reloadDataFinish else { return }

        FloatViewManager.animate()
        viewModel.applyFilter()
        tableView.reloadData()

        if needScrollToEnd {
            scrollToBottom()
        }
    }

    private func setupSearchBar() {
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    private func scrollToBottom() {
        if tableView.numberOfSections > 0 {
            let lastSection = tableView.numberOfSections - 1
            let lastRow = tableView.numberOfRows(inSection: lastSection) - 1

            if lastRow >= 0 {
                let indexPath = IndexPath(row: lastRow, section: lastSection)
                tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
        }
    }

    // MARK: - UISearchBarDelegate

    func searchBar(_: UISearchBar, textDidChange searchText: String) {
        viewModel.networkSearchWord = searchText
        viewModel.applyFilter()
        tableView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.resignFirstResponder()
        viewModel.applyFilter()
        tableView.reloadData()
    }
}

extension NetworkViewController: UITableViewDelegate, UITableViewDataSource {
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            NetworkTableViewCell.self,
            forCellReuseIdentifier: "NetworkCell"
        )

        // Configure constraints for the tableView
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    // MARK: - UITableViewDataSource

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        viewModel.models.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: "NetworkCell", for: indexPath
            ) as! NetworkTableViewCell
        cell.setup(viewModel.models[indexPath.row])

        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = viewModel.models[indexPath.row]
        let controller = NetworkViewControllerDetail(model: model)
        navigationController?.pushViewController(controller, animated: true)
    }
}
