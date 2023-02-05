//
//  NewsViewController.swift
//  RSS_reader
//
//  Created by Diana Samusenka on 2.02.23.
//

import SnapKit
import UIKit
import CoreData

final class NewsViewController: UIViewController {
    
    // MARK: Properties
    
    private var rssItems = [RSSItem]()
    private let lentaURLString = "https://lenta.ru/rss"
    
    // MARK: UI Components
    
    private let refreshControl = UIRefreshControl()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = true
        tableView.register(NewsItemTableViewCell.self, forCellReuseIdentifier: NewsItemTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.allowsMultipleSelection = false
        return tableView
    }()
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicatorView
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.snp.makeConstraints {
            $0.centerY.centerX.equalToSuperview()
        }
        activityIndicatorView.startAnimating()

        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        configureUI()
        
        fetchData()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rssItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NewsItemTableViewCell.identifier,
            for: indexPath
        ) as? NewsItemTableViewCell else {
            fatalError("NewsItemTableViewCell can't be created")
        }
        cell.selectionStyle = .none
        cell.setUpData(
            title: rssItems[indexPath.row].title,
            date: rssItems[indexPath.row].pubDate,
            imageURL: rssItems[indexPath.row].imageURL
        )
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = NewsDescriptionViewController(rssItem: rssItems[indexPath.row])
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - Private Methods

private extension NewsViewController {
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    func configureUI() {
        title = "LENTARU"
        navigationController?.view.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
        configureTableView()
    }
    
    func fetchData() {
        let parser = NewsParser()
        parser.parseFeed(url: lentaURLString) { [weak self] (rssItems) in
            self?.rssItems = rssItems
            
            DispatchQueue.main.async{ [weak self] in
                self?.activityIndicatorView.stopAnimating()
                self?.tableView.reloadData()
            }
        }
    }
    
    @objc func didPullToRefresh(_ sender: Any) {
        fetchData()
        refreshControl.endRefreshing()
    }
}
