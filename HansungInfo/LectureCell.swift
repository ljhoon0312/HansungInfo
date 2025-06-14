//
//  LectureCell.swift
//  HansungInfo
//
//  Created by 이재훈 on 6/15/25.
//

import Foundation
import UIKit

class LectureCell: UITableViewCell {
    
    private let subjectLabel = UILabel()
    private let classLabel = UILabel()
    private let professorLabel = UILabel()
    private let roomLabel = UILabel()
    private let timeLabel = UILabel()
    
    private let hStack1 = UIStackView()
    private let hStack2 = UIStackView()
    private let vStack = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupLayout()
    }
    
    private func setupUI() {
        // 폰트 및 줄수 설정
        subjectLabel.font = UIFont.boldSystemFont(ofSize: 18)
        subjectLabel.numberOfLines = 0
        
        classLabel.font = UIFont.systemFont(ofSize: 16)
        classLabel.numberOfLines = 1
        
        professorLabel.font = UIFont.systemFont(ofSize: 16)
        professorLabel.numberOfLines = 1
        
        roomLabel.font = UIFont.systemFont(ofSize: 16)
        roomLabel.numberOfLines = 1
        
        timeLabel.font = UIFont.systemFont(ofSize: 16)
        timeLabel.numberOfLines = 1
        
        // hugging & compression priority 설정
        subjectLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        subjectLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        let others = [classLabel, professorLabel, roomLabel, timeLabel]
        for label in others {
            label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        }
        
        // 스택뷰 설정
        hStack1.axis = .horizontal
        hStack1.distribution = .fill
        hStack1.spacing = 12
        hStack1.alignment = .leading
        
        hStack2.axis = .horizontal
        hStack2.distribution = .fill
        hStack2.spacing = 12
        hStack2.alignment = .leading
        
        vStack.axis = .vertical
        vStack.spacing = 6
        vStack.alignment = .leading
        
        // 스택뷰에 라벨 추가
        hStack1.addArrangedSubview(subjectLabel)
        hStack1.addArrangedSubview(classLabel)
        
        hStack2.addArrangedSubview(professorLabel)
        hStack2.addArrangedSubview(roomLabel)
        hStack2.addArrangedSubview(timeLabel)
        
        vStack.addArrangedSubview(hStack1)
        vStack.addArrangedSubview(hStack2)
        
        contentView.addSubview(vStack)
    }
    
    private func setupLayout() {
        vStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            vStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            vStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            vStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func configure(with lecture: Lecture) {
        subjectLabel.text = lecture.subject
        classLabel.text = "분반: \(lecture.classNum)"
        professorLabel.text = lecture.professor
        roomLabel.text = lecture.room
        timeLabel.text = lecture.time
    }
}
