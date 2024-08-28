//
//  ArtistDetailOrderOption.swift
//  Author
//
//  Created by 이숭인 on 8/9/24.
//

import Foundation

enum ArtistDetailOrderOption: String, CaseIterable {
    case name
    case pureIndexHigh
    case rating
    
    var identifier: String {
        return self.rawValue
    }
    
    var title: String {
        switch self {
        case .name:
            return "이름순"
        case .pureIndexHigh:
            return "퓨어지수 높은순"
        case .rating:
            return "등급 낮은 순"
        }
    }
}
