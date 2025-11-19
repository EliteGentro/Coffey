//
//  Content.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 17/10/25.
//


import Foundation
import SwiftData
import System
import Combine

@Model
class Content: Identifiable, Decodable, Hashable, Encodable  {
    @Attribute(.unique) var id : UUID
    var content_id : Int
    var name: String
    var details : String
    var url : String
    var resourceType: String
    var transcript : String
    var isDownloaded: Bool
    var updatedAt: Date?
    var deletedAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case name, content_id, details, url, resourceType, transcript, updatedAt, deletedAt
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.content_id = try container.decode(Int.self, forKey: .content_id)
        self.name = try container.decode(String.self, forKey: .name)
        self.details = try container.decode(String.self, forKey: .details)
        self.url = try container.decode(String.self, forKey: .url)
        self.resourceType = try container.decode(String.self, forKey: .resourceType)
        self.transcript = try container.decode(String.self, forKey: .transcript)
        self.isDownloaded = false
        self.updatedAt = try container.decodeIfPresent(Date.self, forKey: .updatedAt)
        self.deletedAt = try container.decodeIfPresent(Date.self, forKey: .deletedAt)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.content_id, forKey: .content_id)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.details, forKey: .details)
        try container.encode(self.url, forKey: .url)
        try container.encode(self.resourceType, forKey: .resourceType)
        try container.encode(self.transcript, forKey: .transcript)
        try container.encodeIfPresent(self.updatedAt, forKey: .updatedAt)
        try container.encodeIfPresent(self.deletedAt, forKey: .deletedAt)
    }
    
    init(
        id:UUID = UUID(),
        content_id: Int,
        name: String,
        details: String,
        url: String,
        resourceType: String,
        transcript: String,
        isDownloaded :Bool,
        updatedAt: Date? = nil,
        deletedAt: Date? = nil
    ){
        self.id = id
        self.content_id = content_id
        self.name = name
        self.details = details
        self.url = url
        self.resourceType = resourceType
        self.transcript = transcript
        self.isDownloaded = isDownloaded
        self.updatedAt = updatedAt
        self.deletedAt = deletedAt
    }
    
    static let mockContents: [Content] = [
        Content(content_id: 1, name:"Cultura del ahorro1", details: "Muestra la importancia de dar prioridades de gasto con el dinero que recibimos, ya sea por sueldo, honorarios o comisiones separando una cantidad para crear una cultura del ahorro.", url: "https://cdn1.capacitateparaelempleo.org/vidhosting/GCDj0Wqxlb0.mp4", resourceType: "video", transcript: "Cultura del ahorro Durante este viaje financiero, aprenderás a optimizar tus recursos, mejorarás tus hábitos de ahorro y realizarás inversiones para lograr una conciencia financiera, lo que te generará beneficios a ti y a tus seres queridos. La cultura que fortalece las bases para que logres tus objetivos personales, familiares y hasta empresariales es la cultura del ahorro. (1 3s] El ahorro se puede definir como la cantidad que se separa del ingreso mensual con el fin de utilizarlo posteriormente para realizar algo planeado o bien, contar con la cantidad necesaria en caso de tener un imprevisto o emergencia. (3.5s/ El ahorro no solo se aplica al dinero. También se puede ahorrar energía. Para lograrlo, en tu hogar puedes modificar tus hábitos y así reducir el consumo de agua, gas, internet, servicio de telefonía fija y energía eléctrica. También puedes reducir el consumo de gasolina utilizando el transporte público o alternativas no motorizadas como la bicicleta.", isDownloaded: false),
        Content(content_id: 2, name:"Cultura de inversión", details: "Muestra la importancia de dar prioridades de gasto con el dinero que recibimos, ya sea por sueldo, honorarios o comisiones separando una cantidad para crear una cultura del ahorro.", url: "https://cdn1.capacitateparaelempleo.org/vidhosting/himjRYa_WBo.mp4", resourceType: "video", transcript: "Cultura del ahorro Durante este viaje financiero, aprenderás a optimizar tus recursos, mejorarás tus hábitos de ahorro y realizarás inversiones para lograr una conciencia financiera, lo que te generará beneficios a ti y a tus seres queridos. La cultura que fortalece las bases para que logres tus objetivos personales, familiares y hasta empresariales es la cultura del ahorro. (1 3s] El ahorro se puede definir como la cantidad que se separa del ingreso mensual con el fin de utilizarlo posteriormente para realizar algo planeado o bien, contar con la cantidad necesaria en caso de tener un imprevisto o emergencia. (3.5s/ El ahorro no solo se aplica al dinero. También se puede ahorrar energía. Para lograrlo, en tu hogar puedes modificar tus hábitos y así reducir el consumo de agua, gas, internet, servicio de telefonía fija y energía eléctrica. También puedes reducir el consumo de gasolina utilizando el transporte público o alternativas no motorizadas como la bicicleta.",isDownloaded: false),
        Content(content_id: 3, name:"Planeación ", details: "Muestra la importancia de dar prioridades de gasto con el dinero que recibimos, ya sea por sueldo, honorarios o comisiones separando una cantidad para crear una cultura del ahorro.", url:"https://cdn1.capacitateparaelempleo.org/vidhosting/3i-RzPnThHk.mp4", resourceType: "file", transcript: "Cultura del ahorro Durante este viaje financiero, aprenderás a optimizar tus recursos, mejorarás tus hábitos de ahorro y realizarás inversiones para lograr una conciencia financiera, lo que te generará beneficios a ti y a tus seres queridos. La cultura que fortalece las bases para que logres tus objetivos personales, familiares y hasta empresariales es la cultura del ahorro. (1 3s] El ahorro se puede definir como la cantidad que se separa del ingreso mensual con el fin de utilizarlo posteriormente para realizar algo planeado o bien, contar con la cantidad necesaria en caso de tener un imprevisto o emergencia. (3.5s/ El ahorro no solo se aplica al dinero. También se puede ahorrar energía. Para lograrlo, en tu hogar puedes modificar tus hábitos y así reducir el consumo de agua, gas, internet, servicio de telefonía fija y energía eléctrica. También puedes reducir el consumo de gasolina utilizando el transporte público o alternativas no motorizadas como la bicicleta.", isDownloaded: false)
    ]

    static func isValidContent(_ name: String, _ details: String, _ url: String ,_ resourceType: String ,_ transcript: String ,_ isDownloaded: Bool ) -> Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !details.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !url.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !resourceType.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !transcript.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !isDownloaded
    }
    
}
