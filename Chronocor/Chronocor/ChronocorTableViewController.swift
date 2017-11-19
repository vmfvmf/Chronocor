//
//  ChronocorTableViewController.swift
//  Chronocor
//
//  Created by Vinicius Martins Ferraz on 19/11/17.
//  Copyright © 2017 Vinicius Martins Ferraz. All rights reserved.
//

import UIKit
import EventKit

class ChronocorTableViewController: UITableViewController {
    // MARK: properties
     var chronocors = [Chronocor]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadChronocors()

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
        return 1//chronocors.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ChronocorTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ChronocorTableViewCell  else { fatalError("The dequeued cell is not an instance of ChronocrTableViewCell.") }

        // Fetches the appropriate meal for the data source layout.
        let chron = chronocors[indexPath.row]
        let calendar = Calendar.current
     
        cell.dia.text = "01"//calendar.component(.day, from: chron.diaTrabalho.startDate).description
        cell.ano.text = "02"//calendar.component(.year, from: chron.diaTrabalho.startDate).description
        cell.mes.text = "2017"//calendar.component(.month, from: chron.diaTrabalho.startDate).description
        
        cell.entradaTrab.text = "12:00"//calendar.component(.hour, from: chron.diaTrabalho.startDate).description
        cell.saidaTrab.text = "23:00"//calendar.component(.hour, from: chron.diaTrabalho.endDate).description

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK:  private methods
    private func loadChronocors(){
        let eventStore = EKEventStore()
        let calendars = eventStore.calendars(for: .event)
        for calendar in calendars {
            if calendar.title == "Chronocor" {
                NSLog("Chronocor")
                let inicio = Calendar.current.date(byAdding: DateComponents(day: -10), to: NSDate() as Date)!
                let fim = Calendar.current.date(byAdding: DateComponents(day: 10), to: inicio)!
                let predicate = eventStore.predicateForEvents(
                    withStart: inicio,
                    end: fim,
                    calendars: [calendar])
                for event in eventStore.events(matching: predicate){
                    chronocors += [Chronocor(diaTrabalho: event,horarioAlmoco: event)]
                    NSLog("Adicionar evento")
                }
            }
        }
    }
}
