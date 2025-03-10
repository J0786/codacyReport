//
//  HomeVC.swift
//  CopperHeat
//
//  Created by vtadmin on 04/10/24.
//

import UIKit
import CoreData

struct DeviceModel: Codable {
    var host: String?
    var password: String?
    var deviceName: String?
    var id: Int?
}

class HomeVC: BaseVC {
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var tblview: UITableView!
    var arrDeviceData: [DeviceModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        img.cornerRadius(cornerRadius: 5)
        setupView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        self.navigationController?.isNavigationBarHidden = true
    }
    @IBAction func actionBtnAdd(_ sender: UIButton) {
        if let addDeviceVC = storyBoard.instantiateViewController(withIdentifier: "AddDeviceVC") as? AddDeviceVC {
            addDeviceVC.delegate = self
            self.present(addDeviceVC, animated: true)
        }
    }
}

extension HomeVC: AddNewDel {
    func addNew(host: String, password: String, deviceName: String) {
        getArray()
        checkNoData()
        navigateToConnect(host: host, password: password)
    }
}

extension HomeVC {
    func setupView() {
        arrDeviceData.removeAll()
        let nib = UINib(nibName: "HomeCell", bundle: nil)
        tblview.register(nib, forCellReuseIdentifier: "HomeCell")
        tblview.delegate = self
        tblview.dataSource = self
        btnAdd.round()
        getArray()
    }
    func checkNoData() {
        if arrDeviceData.count <= 0 {
            self.setNoData(scrollView: tblview)
        }
        tblview.reloadData()
    }
    func navigateToConnect(host: String, password: String) {
        if let deskViewVC = storyBoard.instantiateViewController(withIdentifier: "DeskViewVC") as? DeskViewVC {
            deskViewVC.host = host
            deskViewVC.password = password
            deskViewVC.port = 5900
            self.navigationController?.pushViewController(deskViewVC, animated: true)
        }
    }
    func getArray() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ConnectionItem")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            if let userResult = result as? [NSManagedObject] {
                print(userResult)
                AppDelegate.user = userResult
            } else {
                print("Failed to cast result to [NSManagedObject]")
            }
            AppDelegate.user.reverse()
            print(convertToJSONArray(moArray: AppDelegate.user))
            let arr = convertToJSONArray(moArray: AppDelegate.user)
            self.arrDeviceData.removeAll()
            if arr.count > 0 {
                for index in 0..<arr.count {
                    let dict = arr[index]
                    let model = DeviceModel(
                        host: (dict["host"] as? String) ?? "",
                        password: (dict["password"] as? String) ?? "",
                        deviceName: (dict["device_name"] as? String) ?? "",
                        id: (dict["id"] as? Int) ?? 0
                    )
                    self.arrDeviceData.append(model)
                }
            }
            checkNoData()
        } catch {
            debugPrint("Failed")
        }
    }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrDeviceData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as? HomeCell {
            if arrDeviceData[indexPath.row].deviceName ?? "" == "" {
                cell.lblTitle.text = "Device \(indexPath.row + 1)"
            } else {
                cell.lblTitle.text = arrDeviceData[indexPath.row].deviceName ?? ""
            }
            cell.lblHost.text = arrDeviceData[indexPath.row].host ?? ""
            cell.btnConnect.tag = indexPath.row
            cell.btnConnect.addTarget(self, action: #selector(ationBtnConnect), for: .touchUpInside)
            cell.btnDel.tag = indexPath.row
            cell.btnDel.addTarget(self, action: #selector(ationBtnDelete), for: .touchUpInside)
            cell.selectionStyle = .none
            return cell
        } else {
            return UITableViewCell()
        }
    }
    @IBAction func ationBtnDelete(_ sender: UIButton) {
        self.showAlert(message: "Are you sure you want to delete this device?") {
            self.arrDeviceData.remove(at: sender.tag)
            let data = AppDelegate.user.remove(at: sender.tag)
            context.delete(data)
            do {
                try context.save()
                print(AppDelegate.user.count)
            } catch { }
            self.checkNoData()
        } no: {

        }
    }
    func convertToJSONArray(moArray: [NSManagedObject]) -> [[String: Any]] {
        var jsonArray: [[String: Any]] = []
        for item in moArray {
            var dict: [String: Any] = [:]
            for attribute in item.entity.attributesByName {
                // check if value is present, then add key to dictionary so as to avoid the nil value crash
                if let value = item.value(forKey: attribute.key) {
                    dict[attribute.key] = value
                }
            }
            jsonArray.append(dict)
        }
        return jsonArray.reversed()
    }
    @IBAction func ationBtnConnect(_ sender: UIButton) {
        navigateToConnect(
            host: arrDeviceData[sender.tag].host ?? "",
            password: arrDeviceData[sender.tag].password ?? ""
        )
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { }
}
