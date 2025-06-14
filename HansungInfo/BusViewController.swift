//
//  BusViewController.swift
//  HansungInfo
//
//  Created by 이재훈 on 6/14/25.
//

import UIKit

class BusViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var routeSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var upButton: UIButton!
    
    @IBOutlet weak var downButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    var currentRouteFileName: String = "seongbuk02_up"
    var busStops: [BusStop] = []
    var startTime: String = "06:00"
    var interval: Int = 13

    var etaResults: [String] = []
    var busIndex: Int?
    
    @IBAction func refreshButtonTapped(_ sender: UIBarButtonItem) {
        updateETAs()
        tableView.reloadData()
    }
    
    @IBAction func routeSegmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            currentRouteFileName = "seongbuk02_up"
            setButtonTitle(upButton, title: "한성대 방향")
            setButtonTitle(downButton, title: "지하철역 방향")
            interval = 13
        case 1:
            currentRouteFileName = "jongro03_up"
            setButtonTitle(upButton, title: "낙산공원 방향")
            setButtonTitle(downButton, title: "종로5가 방향")
            interval = 9
        case 2:
            currentRouteFileName = "shuttlebus_up"
            setButtonTitle(upButton, title: "한성대 방향")
            setButtonTitle(downButton, title: "삼선교 방향")
            interval = 30
        default: break
        }
        loadBusData()
    }
    
    @IBAction func upButtonTapped(_ sender: UIButton) {
        currentRouteFileName = currentRouteFileName.replacingOccurrences(of: "_down", with: "_up")
        loadBusData()
    }
    
    @IBAction func downButtonTapped(_ sender: UIButton) {
        currentRouteFileName = currentRouteFileName.replacingOccurrences(of: "_up", with: "_down")
        loadBusData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        upButton.titleLabel?.adjustsFontSizeToFitWidth = true
        downButton.titleLabel?.adjustsFontSizeToFitWidth = true
        upButton.titleLabel?.lineBreakMode = .byTruncatingTail
        downButton.titleLabel?.lineBreakMode = .byTruncatingTail

        loadBusData()

        // Do any additional setup after loading the view.
    }
    
    func setButtonTitle(_ button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.5
        button.titleLabel?.numberOfLines = 1
        button.titleLabel?.lineBreakMode = .byTruncatingTail
    }
    
    func loadBusData() {
        if let path = Bundle.main.path(forResource: currentRouteFileName, ofType: "json"),
           let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
           let route = try? JSONDecoder().decode(BusRoute.self, from: data) {
            self.busStops = route.stations
            self.startTime = route.startTime
            self.interval = route.interval
            updateETAs()
            tableView.reloadData()
        }
    }
    
    func updateETAs() {
        etaResults = []
        busIndex = nil

        let now = Date()
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"

        guard let start = formatter.date(from: startTime) else { return }
        let minutesSinceStart = calendar.dateComponents([.minute], from: start, to: now).minute ?? 0

        for (index, stop) in busStops.enumerated() {
            let timePassed = minutesSinceStart - stop.offset

            if timePassed < 0 {
                etaResults.append("\(abs(timePassed))분")
                if busIndex == nil { busIndex = index }
            } else {
                let busesPassed = timePassed / interval
                let nextArrival = (busesPassed + 1) * interval + stop.offset
                let eta = nextArrival - minutesSinceStart

                if eta <= 1 {
                    etaResults.append("곧 도착")
                    if busIndex == nil { busIndex = index }
                } else {
                    etaResults.append("\(eta)분")
                    if busIndex == nil { busIndex = index }
                }
            }
        }

        print("🕐 Now: \(formatter.string(from: now)), Minutes since start: \(minutesSinceStart)")
        print("🚍 Bus is assumed near index: \(busIndex ?? -1)")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return busStops.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusStopCell", for: indexPath)
        let stop = busStops[indexPath.row]
        let eta = etaResults.indices.contains(indexPath.row) ? etaResults[indexPath.row] : "-"

        cell.textLabel?.text = "\(stop.name)  •  \(eta)"
        if let etaValue = Int(eta.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)), etaValue <= 1 {
            cell.imageView?.image = UIImage(systemName: "bus")
        } else {
            cell.imageView?.image = nil
        }

        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
