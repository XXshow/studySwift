//
//  ListTableViewController.swift
//  ThePhoneBook
//
//  Created by 史宵宵 on 2017/7/25.
//  Copyright © 2017年 史宵宵. All rights reserved.
//  私人通讯录联系

import UIKit

class ListTableViewController: UITableViewController {

    var personList = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData(completion: { [weak self] (array) in
            print(array)
            self?.personList += array
            self?.tableView.reloadData()
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadData (completion:@escaping ( _ list: [Person]) -> ()) -> (){
        DispatchQueue.global().async {
            print("正在加载中")
            Thread.sleep(forTimeInterval: 2)
            
            var array = [Person]()
            for i in 0 ..< 10{
                let p = Person()
                p.name = "张三--\(i)"
                p.phone = "135"+String(format: "%06d", arc4random_uniform(1000000))
                p.work = "boss"
                array .append(p)
            }
            
            DispatchQueue.main.async(execute: { 
                //回调，执行闭包
                completion(_:array)
            })
        }
    }
    // MARK: - Table view data source
    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
     */
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return personList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        cell.textLabel?.text = personList[indexPath.row].name
        cell.detailTextLabel?.text = personList[indexPath.row].phone

        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! DetailTableViewController
        if let indexPath = sender as? IndexPath {
            vc.person  = personList[indexPath.row]
            vc.complate = {
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }else{
            vc.complate = { [weak vc] in
                guard let p = vc?.person else {
                    return
                }
                self.personList.insert(p, at: 0)
                self.tableView.reloadData()
            }
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "listToDetail", sender: indexPath)
    }
    
    
    @IBAction func addDetail(_ sender: Any) {
        performSegue(withIdentifier: "listToDetail", sender: nil)
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

}
