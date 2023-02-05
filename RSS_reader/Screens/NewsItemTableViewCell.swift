//
//  NewsItemTableViewCell.swift
//  RSS_reader
//
//  Created by Diana Samusenka on 3.02.23.
//

import SnapKit
import UIKit

final class NewsItemTableViewCell: UITableViewCell {
    static let identifier = "NewsItemTableViewCell"
    
    // MARK: UI Components
    
    private lazy var itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var pubDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 14, weight: .thin)
        return label
    }()
    
    // MARK: Life cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(itemImageView)
        itemImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(16)
            $0.height.width.equalTo(60)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.right.equalToSuperview().inset(16)
            $0.left.equalTo(itemImageView.snp.right).offset(16)
        }

        contentView.addSubview(pubDateLabel)
        pubDateLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.bottom.equalToSuperview().inset(10)
            $0.right.equalToSuperview().inset(16)
            $0.left.equalTo(itemImageView.snp.right).offset(16)
        }
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        pubDateLabel.text = nil
        itemImageView.image = nil
    }
}

// MARK: Methods

extension NewsItemTableViewCell {
    func setUpData(title: String, date: String, imageURL: String?) {
        titleLabel.text = title
        pubDateLabel.text = date
        guard let imageURLString = imageURL else {
            itemImageView.image = nil
            return
        }
        itemImageView.kf.setImage(with: URL(string: imageURLString))
    }
}
