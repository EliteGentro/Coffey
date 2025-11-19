//
//  Syncable.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 19/11/25.
//

import Foundation
import SwiftData

protocol Syncable: PersistentModel, Identifiable {
    associatedtype IDType: Hashable

    var remoteID: IDType { get set }
    var updatedAt: Date? { get set }
    var deletedAt: Date? { get set }

    static func makeLocal(from remote: Self) -> Self
    func merge(from remote: Self)
}
