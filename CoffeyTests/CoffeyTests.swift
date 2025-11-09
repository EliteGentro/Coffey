//
//  CoffeyTests.swift
//  CoffeyTests
//
//  Created by Alumno on 24/10/25.
//

import Testing
@testable import Coffey
import Foundation

struct CoffeyTests {

    @Test("Name must not be empty or whitespace")
    func testNameValidation() async throws {
        #expect(User.isValidName("Cupertino"))
        #expect(!User.isValidName(""))
        #expect(!User.isValidName(" "))
        #expect(!User.isValidName("  "))
    }
    
    @Test("Content fields must not be empty or whitespace")
    func testContentValidation() async throws {
        #expect(Content.isValidContent("Cultura del ahorro1", "Muestra la importancia de dar prioridades de gasto con el dinero que recibimos, ya sea por sueldo, honorarios o comisiones separando una cantidad para crear una cultura del ahorro.", "https://cdn1.capacitateparaelempleo.org/vidhosting/GCDj0Wqxlb0.mp4", "video", "Cultura del ahorro Durante este viaje financiero, aprenderás a optimizar tus recursos, mejorarás tus hábitos de ahorro y realizarás inversiones para lograr una conciencia financiera, lo que te generará beneficios a ti y a tus seres queridos. La cultura que fortalece las bases para que logres tus objetivos personales, familiares y hasta empresariales es la cultura del ahorro. (1 3s] El ahorro se puede definir como la cantidad que se separa del ingreso mensual con el fin de utilizarlo posteriormente para realizar algo planeado o bien, contar con la cantidad necesaria en caso de tener un imprevisto o emergencia. (3.5s/ El ahorro no solo se aplica al dinero. También se puede ahorrar energía. Para lograrlo, en tu hogar puedes modificar tus hábitos y así reducir el consumo de agua, gas, internet, servicio de telefonía fija y energía eléctrica. También puedes reducir el consumo de gasolina utilizando el transporte público o alternativas no motorizadas como la bicicleta.", false))
        #expect(!Content.isValidContent("", "Muestra la importancia de dar prioridades de gasto con el dinero que recibimos, ya sea por sueldo, honorarios o comisiones separando una cantidad para crear una cultura del ahorro.", "https://cdn1.capacitateparaelempleo.org/vidhosting/GCDj0Wqxlb0.mp4", "video", "Cultura del ahorro Durante este viaje financiero, aprenderás a optimizar tus recursos, mejorarás tus hábitos de ahorro y realizarás inversiones para lograr una conciencia financiera, lo que te generará beneficios a ti y a tus seres queridos. La cultura que fortalece las bases para que logres tus objetivos personales, familiares y hasta empresariales es la cultura del ahorro. (1 3s] El ahorro se puede definir como la cantidad que se separa del ingreso mensual con el fin de utilizarlo posteriormente para realizar algo planeado o bien, contar con la cantidad necesaria en caso de tener un imprevisto o emergencia. (3.5s/ El ahorro no solo se aplica al dinero. También se puede ahorrar energía. Para lograrlo, en tu hogar puedes modificar tus hábitos y así reducir el consumo de agua, gas, internet, servicio de telefonía fija y energía eléctrica. También puedes reducir el consumo de gasolina utilizando el transporte público o alternativas no motorizadas como la bicicleta.", false))
    }

    @Test("Finance fields must not be empty or whitespace or negative")
    func testFinanceValidation() async throws {
        #expect(Finance.isValidFinance("Compra de ropa", "Personal", 200.00, "Egresos"))
        #expect(!Finance.isValidFinance("", "Personal", 200.00, "Egresos"))
        #expect(!Finance.isValidFinance("Compra de ropa", "", 200.00, "Egresos"))
        #expect(!Finance.isValidFinance("Compra de ropa", "Personal", -200.00, "Egresos"))
        #expect(!Finance.isValidFinance("Compra de ropa", "Personal", 200.00, ""))
    }

    @Test("Admin fields must not be empty or whitespace or invalid")
    func testAdminValidation() async throws {
        #expect(Admin.isValidAdmin("Humberto", "mail@mail.com", 123, "12345"))
        #expect(!Admin.isValidAdmin("", "mail@mail.com", 123, "12345"))
        #expect(!Admin.isValidAdmin("Humberto", "", 123, "12345"))
        #expect(!Admin.isValidAdmin("Humberto", "mail@mail.com", 0, "12345"))
        #expect(!Admin.isValidAdmin("Humberto", "mail@mail.com", 123, ""))
        #expect(!Admin.isValidAdmin("Pablo", "mail@mail.com   ", 123, "12345"))
        #expect(!Admin.isValidAdmin("Pedro", "mail@mail.com", 123, "   "))
        #expect(Admin.isValidAdmin("  Pedro  ", "mail@mail.com", 123, "12345"))
        #expect(Admin.isValidAdmin("Pedro", "  mail@mail.com", 123, "12345"))

    }


    @Test("Fecha  válida")
    func testFechaPasada() {
        let fechaPasada = Calendar.current.date(byAdding: .day, value: -1, to: .now)!
        #expect(Finance.isValidFecha(fechaPasada))
        
        let fechaFutura = Calendar.current.date(byAdding: .day, value: 1, to: .now)!
        #expect(!Finance.isValidFecha(fechaFutura))
    }

    @Test("Content API returns HTTP 200")
    func testContentAPIStatus() async throws {
        let url = URL(string: "https://coffey-api.vercel.app/content")!
        let (_, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        #expect(httpResponse.statusCode == 200)
    }

    @Test("Content API decodes to [Content]")
    func testContentAPIDecode() async throws {
        let url = URL(string: "https://coffey-api.vercel.app/content")!
        let (data, _) = try await URLSession.shared.data(from: url)

        #expect(!data.isEmpty)

        let contents = try JSONDecoder().decode([Content].self, from: data)
        if let first = contents.first {
            #expect(first.content_id > 0)
            #expect(!first.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
    }


}
