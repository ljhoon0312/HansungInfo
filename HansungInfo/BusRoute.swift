//
//  BusRoute.swift
//  HansungInfo
//
//  Created by 이재훈 on 6/14/25.
//

import Foundation

struct BusRoute: Codable {
    let route: String
    let direction: String
    let operationTime: String
    let startTime: String
    let interval: Int
    let stations: [BusStop]
}
