//
//  ChronocorTableViewController.swift
//  Chronocor
//
//  Created by Vinicius Martins Ferraz on 19/11/17.
//  Copyright © 2017 Vinicius Martins Ferraz. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI
import os.log

class ChronocorTableViewController: UITableViewController, EKEventEditViewDelegate {
    
    // MARK: properties
    var registros = [RegistroTrabalho]()
    var editingIndexPath : IndexPath?
    @IBOutlet var chronTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationItem.leftBarButtonItem = editButtonItem
        registros = RegistroTrabalho.recuperaRegistrosDeTrabalhos()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return registros.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ChronocorTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ChronocorTableViewCell else { fatalError("The dequeued cell is not an instance of ChronocrTableViewCell."  ) }

        // Fetches the appropriate meal for the data source layout.
        let registro = registros[indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        
        let date = registro.event.startDate!
        dateFormatter.dateFormat = "dd"
        cell.dia.text = dateFormatter.string(from: date)
        // chron.diaTrabalho.startDate
        
        dateFormatter.dateFormat = "yy"
        cell.ano.text = dateFormatter.string(from: date)
        
        // chron.diaTrabalho.startDate
        dateFormatter.dateFormat = "MM"
        cell.mes.text = dateFormatter.string(from: date)
        // chron.diaTrabalho.startDate
        
        dateFormatter.dateFormat = "HH:mm"
        cell.entradaTrab.text = dateFormatter.string(from: registro.event.startDate)
        cell.saidaTrab.text = dateFormatter.string(from: registro.event.endDate)
        
        
        cell.inicioAlmoco.text = dateFormatter.string(from: (registro.event.startDate)!)
        cell.fimAlmoco.text = dateFormatter.string(from: (registro.event.endDate)!)

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            registros[indexPath.item].apagar();
            registros.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
        case "NewEvent":
            editingIndexPath = nil
            let vc = EKEventEditViewController()
            vc.editViewDelegate = self
            vc.event = RegistroTrabalho.init().event
            vc.eventStore = RegistroTrabalho.getEventStore()
            self.present(vc, animated: true, completion: nil)
            os_log("new event", log: OSLog.default, type: .debug)
        case "ShowEvent":
            guard let selectedChronocorCell = (sender as! UIButton).superview?.superview as? ChronocorTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            editingIndexPath = tableView.indexPath(for: selectedChronocorCell)
            let editingEvent = registros[editingIndexPath!.row].event
            let vc = EKEventEditViewController()
            vc.editViewDelegate = self
            vc.event = editingEvent
            vc.eventStore = RegistroTrabalho.getEventStore()
            self.present(vc, animated: true, completion: nil)
            os_log("edit event", log: OSLog.default, type: .debug)
        default:
            fatalError("!!!!Unexpected Segue Identifier; \(String(describing: segue.identifier))")
            
        }
    }
    

    // MARK:  private methods
    @IBAction func trabalhoButton(_ sender: UIButton) {
    }
    
    @IBAction func unwindToRegistroTrabalhoList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ChronocorViewController, let registro = sourceViewController.registro {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                registros[selectedIndexPath.row] = registro
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                let newIndexPath = IndexPath(row: registros.count, section: 0)
                registros.append(registro)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
    }
    
    // MARK: event delegate methods
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        switch action {
        case EKEventEditViewAction.canceled:
            os_log("Btn Cancel", log: OSLog.default, type: .debug)
            self.dismiss(animated: true, completion: nil)
        case EKEventEditViewAction.saved:
            os_log("Btn Save", log: OSLog.default, type: .debug)
            self.dismiss(animated: true, completion: {
                if self.editingIndexPath != nil {
                    let i = self.editingIndexPath!
                    self.tableView.reloadRows(at: [i], with: .none)
                } else {
                    let newIndexPath = IndexPath(row: self.registros.count, section: 0)
                    self.registros.append(RegistroTrabalho(event: controller.event!))
                    self.tableView.insertRows(at: [newIndexPath], with: .automatic)
                }
                })
        default:
            os_log("Não previsto", log: OSLog.default, type: .debug)
        }
        
    }
}
