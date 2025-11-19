//
//  SyncAPI.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 19/11/25.
//

import Foundation


protocol SyncAPI {
    associatedtype Model: Syncable

    func fetchAll() async throws -> [Model]
    func fetchDeleted() async throws -> [Model]
    func create(_ local: Model) async throws -> Model
    func update(_ local: Model) async throws
    func delete(_ local: Model) async throws
}
