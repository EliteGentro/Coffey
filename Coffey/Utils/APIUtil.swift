//
//  APIUtil.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 18/11/25.
//
import Foundation
import Combine

final class APIUtil: ObservableObject {
    func get<T: Decodable>(_ type: T.Type, from endpoint: String) async throws -> T {
        guard let url = URL(string: endpoint) else {
            throw URLError(.badURL)
        }

        let request = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        guard (200..<300).contains(httpResponse.statusCode) else {
            let responseBody = String(data: data, encoding: .utf8) ?? "No response body"
            print("❌ GET \(endpoint) failed with status \(httpResponse.statusCode)")
            print("Response: \(responseBody)")
            throw URLError(.badServerResponse)
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(T.self, from: data)
    }

    func send<T: Encodable>(_ object: T, to endpoint: String, method: String) async throws {
        guard let url = URL(string: endpoint) else { throw URLError(.badURL) }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let jsonData = try encoder.encode(object)
        request.httpBody = jsonData

        if let jsonString = String(data: jsonData, encoding: .utf8) {
            print(jsonString)
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        guard (200..<300).contains(httpResponse.statusCode) else {
            let responseBody = String(data: data, encoding: .utf8) ?? "No response body"
            print("❌ \(method) \(endpoint) failed with status \(httpResponse.statusCode)")
            print("Response: \(responseBody)")
            throw URLError(.badServerResponse)
        }
    }

    func sendAndDecode<T: Decodable, U: Encodable>(
        _ returnType: T.Type,
        _ object: U,
        to endpoint: String,
        method: String
    ) async throws -> T {
        guard let url = URL(string: endpoint) else { throw URLError(.badURL) }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let jsonData = try encoder.encode(object)
        request.httpBody = jsonData

        if let jsonString = String(data: jsonData, encoding: .utf8) {
            print(jsonString)
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        guard (200..<300).contains(httpResponse.statusCode) else {
            let responseBody = String(data: data, encoding: .utf8) ?? "No response body"
            print("❌ \(method) \(endpoint) failed with status \(httpResponse.statusCode)")
            print("Response: \(responseBody)")
            throw URLError(.badServerResponse)
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(T.self, from: data)
    }
}
