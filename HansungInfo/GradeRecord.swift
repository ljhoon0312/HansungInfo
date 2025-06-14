//
//  GradeRecord.swift
//  HansungInfo
//
//  Created by 이재훈 on 6/15/25.
//

import Foundation

struct GradeSemester: Codable {
    let year: Int
    let semester: Int
    let courses: [GradeRecord]
}

struct GradeRecord: Codable {
    let name: String
    let code: String
    let credit: Int
    let grade: String
}
