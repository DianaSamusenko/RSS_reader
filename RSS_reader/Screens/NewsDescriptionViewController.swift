//
//  NewsDescriptionViewController.swift
//  RSS_reader
//
//  Created by Diana Samusenka on 2.02.23.
//

import Kingfisher
import SnapKit
import UIKit

final class NewsDescriptionViewController: UIViewController {
    
    // MARK: Properties
    
    private var rssItem: RSSItem
    
    //MARK: - UI Components
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.font = .systemFont(ofSize: 23, weight: .heavy)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var pubDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 15, weight: .thin)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var linkLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textAlignment = .left
        label.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(openLink))
        label.addGestureRecognizer(tap)
        return label
    }()
        
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .clear
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(200)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        contentView.addSubview(pubDateLabel)
        pubDateLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        
        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(pubDateLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(16)
            
        }
        
        contentView.addSubview(linkLabel)
        linkLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(20)
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(15)
            $0.left.right.equalToSuperview().inset(16)
        }
        return contentView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView.snp.width)
        }
        return scrollView
    }()
    
    //MARK: - Initialization
    
    init(rssItem: RSSItem) {
        self.rssItem = rssItem
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        insertData()
    }
}

//MARK: - Private Methods

private extension NewsDescriptionViewController {
    func configureUI() {
        title = "LENTARU"
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: nil)
        navigationController?.navigationBar.tintColor = .black
        navigationController?.topViewController?.extendedLayoutIncludesOpaqueBars = true

        view.backgroundColor = .white
    }
    
    func insertData() {
        titleLabel.text = rssItem.title
        pubDateLabel.text = rssItem.pubDate
        descriptionLabel.text = rssItem.description
        guard let imageURLString = rssItem.imageURL else {
            imageView.image = nil
            return
        }
        imageView.kf.setImage(with: URL(string: imageURLString))
        
        let link = rssItem.link
        let fullString = "Читать подробнее:\n\(link)"
        let rangeToUnderline = (fullString as NSString).range(of: link)
        let underlineString = NSMutableAttributedString(string: fullString)
        underlineString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: rangeToUnderline)
        linkLabel.attributedText = underlineString
    }
    
    @objc func openLink () {
        guard let linkURL = URL(string: rssItem.link) else { return }
        if UIApplication.shared.canOpenURL(linkURL) {
            UIApplication.shared.open(linkURL, options: [:])
        }
    }
}
