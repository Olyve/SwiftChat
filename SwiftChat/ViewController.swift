//
//  ViewController.swift
//  SwiftChat
//
//  Created by Sam Galizia on 7/15/16.
//  Copyright © 2016 Chexology. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var advertiseSwitch: UISwitch!
  @IBOutlet weak var tableView: UITableView!
  
  // Set a variable equal to the sharedInstance
  let mpcManager = MPCManager.sharedInstance
  let refreshControl = UIRefreshControl()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    
    refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh")
    refreshControl.addTarget(self, action: #selector(ViewController.refreshTable), forControlEvents: .ValueChanged)
    tableView.addSubview(refreshControl)
    
    advertiseSwitch.setOn(false, animated: false)
    advertiseSwitch.addTarget(self,
                              action: #selector(ViewController.updateAdvertise),
                              forControlEvents: .ValueChanged)
    
    // Start browsing when view has loaded
    mpcManager.browser.startBrowsingForPeers()
  }

  
}

// MARK: - Helpers
extension ViewController {
  // Handles starting and stopping advertising of the peer based on the switch
  func updateAdvertise()
  {
    if advertiseSwitch.on {
      mpcManager.advertiser.startAdvertisingPeer()
    }
    else {
      mpcManager.advertiser.stopAdvertisingPeer()
    }
  }
  
  func refreshTable()
  {
    tableView.reloadData()
    refreshControl.endRefreshing()
  }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int
  {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return mpcManager.foundPeers.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
  {
    let cell = tableView.dequeueReusableCellWithIdentifier("peerCell", forIndexPath: indexPath) as UITableViewCell
    
    cell.textLabel?.text = mpcManager.foundPeers[indexPath.row].displayName
    
    return cell
  }
}

extension ViewController: UITableViewDelegate {
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
  {
    let selectedPeer =  mpcManager.foundPeers[indexPath.row]
    
    mpcManager.browser.invitePeer(selectedPeer,
                                  toSession: mpcManager.session,
                                  withContext: nil,
                                  timeout: 10)
  }
}