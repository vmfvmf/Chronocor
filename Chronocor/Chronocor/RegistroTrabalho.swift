//
//  Chronocor.swift
//  Chronocor
//
//  Created by Vinicius Martins Ferraz on 19/11/17.
//  Copyright © 2017 Vinicius Martins Ferraz. All rights reserved.
//

import UIKit
import EventKit

class RegistroTrabalho {
    public static let CHRONOCOR = "Chronocor"
    public static let EVENTO_TRABALHO = "Trabalho"
    var event : EKEvent
    private static var eventStore : EKEventStore?
    
    init(event : EKEvent){
        RegistroTrabalho.eventStore = RegistroTrabalho.getEventStore()
        self.event = event
    }
    
    init(){
        RegistroTrabalho.eventStore = RegistroTrabalho.getEventStore()
        self.event = EKEvent(eventStore: RegistroTrabalho.eventStore!)
        self.event.title = RegistroTrabalho.EVENTO_TRABALHO
        self.event.startDate = Date()
        self.event.endDate = Calendar.current.date(byAdding: .minute, value: 1, to: self.event.startDate)
        self.event.calendar = RegistroTrabalho.getChronocor()
    }
    
    public static func getEventStore() -> EKEventStore{
        if eventStore == nil {
            eventStore = EKEventStore()
        }
        return eventStore!
    }
    
    public static func getChronocor() -> EKCalendar?{
        let eventStore = RegistroTrabalho.getEventStore()
        for calendar in eventStore.calendars(for: .event){
            NSLog("Calendario: " + calendar.title)
            if calendar.title == RegistroTrabalho.CHRONOCOR {
                return calendar
            }
        }
        let calendar = EKCalendar(for: .event, eventStore: eventStore)
        calendar.title = RegistroTrabalho.CHRONOCOR
        calendar.source = eventStore.sources.filter{
            (source: EKSource) -> Bool in
            source.sourceType.rawValue == EKSourceType.local.rawValue
            }.first!
        do {
            try eventStore.saveCalendar(calendar, commit: true)
            registraNovoDiaDeTrabalho()
        }catch {
            fatalError("Erro ao criar calendário chronocor: " + (error as NSError).localizedDescription)
        }
        return calendar
    }
    
    private static func registraNovoDiaDeTrabalho(){
        let registro = RegistroTrabalho()
        registro.salvaRegistro()
    }
    
    private static func criaRegistroHojeTrabalhoSemRegistro(){
        let inicio = Calendar(identifier: .gregorian).startOfDay(for: Date())
        let fim = Calendar(identifier: .gregorian).startOfDay(for: Calendar.current.date(byAdding: DateComponents(day: 1), to: inicio)!)
        let predicate = eventStore!.predicateForEvents(
            withStart: inicio,
            end: fim,
            calendars: [RegistroTrabalho.getChronocor()!])
        let events = eventStore!.events(matching: predicate)
        if events.count < 1 {
            registraNovoDiaDeTrabalho()
        }
    }
    
    public func salvaRegistro(){
        do {
            try RegistroTrabalho.eventStore!.save(self.event, span: .thisEvent, commit: true)
        } catch {
            print("Erro ao registra evento no calendário: " + (error as NSError).localizedDescription)
        }
    }
    
    public func apagar(){
        do{
            try RegistroTrabalho.getEventStore().remove(self.event, span: .thisEvent, commit: true)
        }
        catch {
            assertionFailure("Erro ao excluir evento" + (error as NSError).localizedDescription)
        }
    }
    
    public static func recuperaRegistrosDeTrabalhos() -> [RegistroTrabalho] {
        var chronocors = [RegistroTrabalho]()
        guard let calendar = RegistroTrabalho.getChronocor() else { fatalError("Chronocor não existe") }
        
        // verifica se existe registro do dia de hoje, e se não possuir cria o registro
        criaRegistroHojeTrabalhoSemRegistro()
        
        // recupera os eventos dentro de um periodo de 30 dias
        let inicio = Calendar.current.date(byAdding: DateComponents(day: -30), to: NSDate() as Date)!
        let fim = Date()
        
        let predicate = RegistroTrabalho.eventStore!.predicateForEvents(
            withStart: inicio,
            end: fim,
            calendars: [calendar])
        
        for event in RegistroTrabalho.eventStore!.events(matching: predicate){
            chronocors.append(RegistroTrabalho(event: event))
        }
        return chronocors
    }
}

enum TipoEvento{
    case Trabalho, Almoco
}
