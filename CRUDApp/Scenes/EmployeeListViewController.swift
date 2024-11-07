//
//  EmployeeListViewController.swift
//  CRUDApp
//
//  Created by Naga Divya Bobbara on 07/11/24.
//

import UIKit
import Network

class EmployeeListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var employeeListTableView: UITableView!
    public static let cellIdentifier = "FIBExplanationTableViewCell"
    
    var empData = [EmployeeDetails]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        employeeListTableView.register(UINib(nibName: EmployeeDetailsTableViewCell.cellIdentifier, bundle: nil), forCellReuseIdentifier: EmployeeDetailsTableViewCell.cellIdentifier)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getEmpDetails()
        self.employeeListTableView.reloadData()
    }
    
    @IBAction func addEmpPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let employeeProfileInfoVC = storyboard.instantiateViewController(identifier: "ProfileInfoViewController")
        self.navigationController?.pushViewController(employeeProfileInfoVC, animated: true)
    }
    
    func getEmpDetails() {
            if let fetchedData = EmployeeDataManager.shared.fetchEmployeeDetails() {
                empData = fetchedData
            }
        }


}

extension EmployeeListViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return empData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let details = empData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: EmployeeDetailsTableViewCell.cellIdentifier, for: indexPath) as! EmployeeDetailsTableViewCell
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none

        let dobString = dateFormatter.string(from: details.dob ?? Date())
        cell.nameLabel.text = details.name
        cell.emailLabel.text = details.email
        cell.dobLabel.text = dobString
        print("")
        cell.mobileNumberLabel.text = details.mobile
        
        cell.selectionStyle  = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedEmployee = empData[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let employeeProfileInfoVC = storyboard.instantiateViewController(identifier: "ProfileInfoViewController") as? ProfileInfoViewController {
            // Pass the selected employee data to ProfileInfoViewController
            employeeProfileInfoVC.selectedEmployee = selectedEmployee
            self.navigationController?.pushViewController(employeeProfileInfoVC, animated: true)
        }
    }
}

extension UIViewController {
    
    func isInternetAvailable() -> Bool {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue.global(qos: .background)
        monitor.start(queue: queue)
        
        var isConnected = false
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                isConnected = true
            } else {
                isConnected = false
            }
        }
        
        // Wait for network status to be updated
        sleep(1)  // Sleep to allow network status to be updated before returning
        
        monitor.cancel()
        return isConnected
    }
}
