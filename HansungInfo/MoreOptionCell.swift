//
//  MoreOptionCell.swift
//  HansungInfo
//
//  Created by 이재훈 on 6/18/25.
//

import UIKit

class MoreOptionCell: UICollectionViewCell {
    
    private let icon = UIImageView()
    private let title = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.tintColor = .systemBlue
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .systemFont(ofSize: 14)
        title.textAlignment = .center
        title.numberOfLines = 2
        
        contentView.addSubview(icon)
        contentView.addSubview(title)
        
        NSLayoutConstraint.activate([
            icon.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            icon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            icon.widthAnchor.constraint(equalToConstant: 30),
            icon.heightAnchor.constraint(equalToConstant: 30),
            
            title.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 8),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            title.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with option: MoreOption) {
        icon.image = UIImage(systemName: option.icon)
        title.text = option.title
    }
}
