//
//  UserProgress.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 21/10/25.
//


import SwiftData
import Foundation

@Model
class Progress: Identifiable, Hashable, Decodable {
    @Attribute(.unique) var id: UUID
    var progress_id : Int
    var user_id: Int
    var content_id: Int
    var status: ProgressStatus
    var local_user_reference: UUID

    
    enum CodingKeys: String, CodingKey {
        case progress_id, user_id, content_id, status
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.progress_id = try container.decode(Int.self, forKey: .progress_id)
        self.user_id = try container.decode(Int.self, forKey: .user_id)
        self.content_id = try container.decode(Int.self, forKey: .content_id)
        self.status = try container.decode(ProgressStatus.self, forKey: .status)
        self.local_user_reference = UUID()
    }
    
    init(
        id: UUID = UUID(),
        progress_id : Int,
        user_id: Int,
        content_id: Int,
        status: ProgressStatus,
        local_user_reference: UUID
    ) {
        self.id = id
        self.progress_id = progress_id
        self.user_id = user_id
        self.content_id = content_id
        self.status = status
        self.local_user_reference = local_user_reference
    }
    
    // Mock data
    static let mockProgresses: [Progress] = [
        Progress(progress_id:1, user_id: 1, content_id: 1, status: ProgressStatus.notStarted, local_user_reference: User.mockUsers[0].id),
        Progress(progress_id:2, user_id: 1, content_id: 2, status: ProgressStatus.inProgress, local_user_reference: User.mockUsers[0].id),
        Progress(progress_id:3, user_id: 1, content_id: 3, status: ProgressStatus.completed, local_user_reference: User.mockUsers[0].id)
    ]
}

//Se va a usar rawstatus para subirlo a la DB
enum ProgressStatus: String, Codable {
    case notStarted
    case inProgress
    case completed
}
