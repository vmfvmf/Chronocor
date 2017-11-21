//
//  ChronocorViewController.swift
//  Chronocor
//
//  Created by Vinicius Martins Ferraz on 18/11/17.
//  Copyright © 2017 Vinicius Martins Ferraz. All rights reserved.
//

import UIKit
import EventKit
import os.log

class ChronocorViewController: UIViewController {
    // MARK: properties
    @IBOutlet weak var cancelBtn: UIBarButtonItem!
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    @IBOutlet weak var entrada: UIDatePicker!
    @IBOutlet weak var saida: UIDatePicker!
    var registro : RegistroTrabalho?

    override func viewDidLoad() {
        super.viewDidLoad()
        saida.addTarget(self, action: #selector(saidaChanged), for: .valueChanged)
        if let registro = registro{
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
            dateFormatter.dateFormat = "dd/MM/yyyy"
            navigationItem.title = dateFormatter.string(from: registro.event.startDate)
            entrada.date = registro.event.startDate
            saida.date = registro.event.endDate
            
        }
        saveBtn.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveBtn else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        registro = RegistroTrabalho()
        registro?.event.startDate = entrada.date
        registro?.event.endDate = Calendar(identifier: .gregorian).date(bySettingHour: Calendar.current.component(.hour, from: saida.date), minute: Calendar.current.component(.minute, from: saida.date), second: 0, of: entrada.date)!
        NSLog("Entrada: " + entrada.date.description + " | Saída: " + saida.date.description)
        registro?.salvaRegistro()
    }

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: private funcs
    @objc private func saidaChanged(_ sender: UIDatePicker){
        if(saida.date <= entrada.date){
            saveBtn.isEnabled = false
        }else{
            saveBtn.isEnabled = true
        }
    }
}

