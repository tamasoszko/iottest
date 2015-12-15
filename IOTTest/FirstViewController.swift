//
//  FirstViewController.swift
//  IOTTest
//
//  Created by Tamás Oszkó on 12/12/15.
//  Copyright © 2015 Tamás Oszkó. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, JBLineChartViewDelegate, JBLineChartViewDataSource, UITableViewDelegate, UITableViewDataSource {

    weak var refreshControl : UIRefreshControl?
    weak var chartView: JBLineChartView?
    @IBOutlet weak var tableView: UITableView!
    
    var dhtDataCache: [Data<DHTData>]?
    var lastData: Data<DHTData>?
    var dhtMeter = DHTMeter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        tableView.addSubview(refresh)
        self.refreshControl = refresh
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
        refreshData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refresh(refreshControl: UIRefreshControl) -> Void {
        refreshControl.beginRefreshing()
        refreshData()
    }
    
    private func refreshData() -> Void {
        dhtMeter.update { (data: [Data<DHTData>]?, last: Data<DHTData>?) -> Void in
            if let dhtData = data, let last = last {
                self.dhtDataCache = dhtData
                self.lastData = last
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.refreshControl?.endRefreshing()
                    self.updateUI()
                })
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("dataCell")
            cell?.textLabel?.text = lastTemp()
            cell?.detailTextLabel?.text = "Temperature"
            return cell!
        } else if indexPath.row == 1 {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("dataCell")
            cell?.textLabel?.text = lastHumid()
            cell?.detailTextLabel?.text = "Humidity"
            return cell!
        } else {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("chartCell")
            if self.chartView == nil {
                self.chartView = cell?.contentView.viewWithTag(1) as? JBLineChartView
                self.chartView?.delegate = self
                self.chartView?.dataSource = self
                self.chartView?.minimumValue = 15
                self.chartView?.maximumValue = 45
            }
            let label = cell?.contentView.viewWithTag(2) as! UILabel
            label.text = lastUpdate()
            return cell!
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.row {
        case 0...1:
            return 64
        case 2:
            return 360
        default:
            return 44
        }
    }

    func lineChartView(lineChartView: JBLineChartView!, colorForLineAtLineIndex lineIndex: UInt) -> UIColor! {
        if lineIndex == 0 {
            return UIColor.redColor()
        }
        return UIColor.blueColor()
    }
    
    func lineChartView(lineChartView: JBLineChartView!, smoothLineAtLineIndex lineIndex: UInt) -> Bool {
        return true
    }
    
    func lineChartView(lineChartView: JBLineChartView!, widthForLineAtLineIndex lineIndex: UInt) -> CGFloat {
        return 1
    }
    
    func lineChartView(lineChartView: JBLineChartView!, showsDotsForLineAtLineIndex lineIndex: UInt) -> Bool {
        return true
    }
    
    func lineChartView(lineChartView: JBLineChartView!, dotViewAtHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> UIView! {
        if horizontalIndex % 12 == 0 {
            let v = UILabel(frame: CGRect(x: 0, y: 0, width: 12, height: 12))
            v.text = "\(horizontalIndex/4)"
            v.textColor = UIColor.whiteColor()
            v.textAlignment = NSTextAlignment.Center
            v.backgroundColor = self.lineChartView(lineChartView, colorForLineAtLineIndex: lineIndex)
            v.font = UIFont(name: "HelveticaNeue-Bold", size: 7)
            v.layer.cornerRadius = v.frame.size.width / 2
            v.layer.masksToBounds = true
            return v
        }
        return UIView()
    }
    
    func lineChartView(lineChartView: JBLineChartView!, verticalValueForHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> CGFloat {
        let data = self.dhtDataCache
        let dhtData = data![Int(horizontalIndex)]
        if lineIndex == 0 {
            return CGFloat(dhtData.data.temperature)
        } else {
            return CGFloat(dhtData.data.humidity)
        }
    }
    
    func numberOfLinesInLineChartView(lineChartView: JBLineChartView!) -> UInt {
        return 2
    }
    
    func lineChartView(lineChartView: JBLineChartView!, numberOfVerticalValuesAtLineIndex lineIndex: UInt) -> UInt {
        if let data = self.dhtDataCache {
            return UInt(data.count)
        }
        return 0
    }
    
    private func updateUI() {
        tableView.reloadData()
        if let chart = self.chartView {
            chart.reloadData()
        }
    }
    
    private func lastTemp() -> String {
        if let last = lastData {
            return "\(last.data.temperature) \u{2103}"
        }
        return "-"
    }
    
    private func lastHumid() -> String {
        if let last = lastData {
            return "\(last.data.humidity) %"
        }
        return "-"
    }
    
    private func lastUpdate() -> String {
        if let last = lastData {
            return "\(last.modified.localizedDiff(NSDate()))"
        }
        return "-"
    }
}

