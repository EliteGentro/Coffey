//
//  CoffeyTests.swift
//  CoffeyTests
//
//  Created by Alumno on 24/10/25.
//

import Testing
@testable import Coffey

struct CoffeyTests {

    @Test("Name must not be empty or whitespace")
    func testNameValidation() async throws {
        #expect(User.isValidName("Cupertino"))
        #expect(!User.isValidName(""))
        #expect(!User.isValidName(" "))
    }
    
    @Test("Content fields must not be empty or whitespace")
    func testContentValidation() async throws {
        #expect(Content.isValidContent("Cultura del ahorro1", "Muestra la importancia de dar prioridades de gasto con el dinero que recibimos, ya sea por sueldo, honorarios o comisiones separando una cantidad para crear una cultura del ahorro.", "https://cdn1.capacitateparaelempleo.org/vidhosting/GCDj0Wqxlb0.mp4", "video", "Cultura del ahorro Durante este viaje financiero, aprenderás a optimizar tus recursos, mejorarás tus hábitos de ahorro y realizarás inversiones para lograr una conciencia financiera, lo que te generará beneficios a ti y a tus seres queridos. La cultura que fortalece las bases para que logres tus objetivos personales, familiares y hasta empresariales es la cultura del ahorro. (1 3s] El ahorro se puede definir como la cantidad que se separa del ingreso mensual con el fin de utilizarlo posteriormente para realizar algo planeado o bien, contar con la cantidad necesaria en caso de tener un imprevisto o emergencia. (3.5s/ El ahorro no solo se aplica al dinero. También se puede ahorrar energía. Para lograrlo, en tu hogar puedes modificar tus hábitos y así reducir el consumo de agua, gas, internet, servicio de telefonía fija y energía eléctrica. También puedes reducir el consumo de gasolina utilizando el transporte público o alternativas no motorizadas como la bicicleta.", false))
    }

}
