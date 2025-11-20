//
//  UserProgress.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 21/10/25.
//


import SwiftData
import Foundation

@Model
final class Progress: Identifiable, Hashable, Codable  {
    @Attribute(.unique) var id: UUID
    var progress_id : Int
    var user_id: Int
    var content_id: Int
    var grade : Int
    var status: ProgressStatus
    var local_user_reference: UUID
    var updatedAt: Date?
    var deletedAt: Date?

    
    enum CodingKeys: String, CodingKey {
        case progress_id, user_id, content_id, grade, status, updatedAt, deletedAt
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.progress_id = try container.decode(Int.self, forKey: .progress_id)
        self.user_id = try container.decode(Int.self, forKey: .user_id)
        self.content_id = try container.decode(Int.self, forKey: .content_id)
        self.grade = try container.decode(Int.self, forKey: .grade)
        self.status = try container.decode(ProgressStatus.self, forKey: .status)
        self.local_user_reference = UUID()
        self.updatedAt = try container.decodeIfPresent(Date.self, forKey: .updatedAt)
        self.deletedAt = try container.decodeIfPresent(Date.self, forKey: .deletedAt)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.user_id, forKey: .user_id)
        try container.encode(self.content_id, forKey: .content_id)
        try container.encode(self.grade, forKey: .grade)
        try container.encode(self.status, forKey: .status)
    }
    
    init(
        id: UUID = UUID(),
        progress_id : Int,
        user_id: Int,
        content_id: Int,
        grade: Int,
        status: ProgressStatus,
        local_user_reference: UUID,
        updatedAt: Date? = nil,
        deletedAt: Date? = nil
    ) {
        self.id = id
        self.progress_id = progress_id
        self.user_id = user_id
        self.content_id = content_id
        self.grade = grade
        self.status = status
        self.local_user_reference = local_user_reference
        self.updatedAt = updatedAt
        self.deletedAt = deletedAt
    }
    
    // Mock data
    static let mockProgresses: [Progress] = [
        Progress(progress_id:1, user_id: 1, content_id: 1, grade: 100, status: ProgressStatus.notStarted, local_user_reference: User.mockUsers[0].id),
        Progress(progress_id:2, user_id: 1, content_id: 2, grade: 80, status: ProgressStatus.inProgress, local_user_reference: User.mockUsers[0].id),
        Progress(progress_id:3, user_id: 1, content_id: 3, grade: 60, status: ProgressStatus.completed, local_user_reference: User.mockUsers[0].id)
    ]
}

//Se va a usar rawstatus para subirlo a la DB
enum ProgressStatus: String, Codable {
    case notStarted
    case inProgress
    case completed
}
