//
//  MPCManager.swift
//  SwiftChat
//
//  Created by chexology on 7/15/16.
//  Copyright © 2016 Chexology. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class MPCManager: NSObject {
  let peerID: MCPeerID
  let serviceType: String
  let discoveryInfo: [String : String]? = nil
  let browser: MCNearbyServiceBrowser
  let advertiser: MCNearbyServiceAdvertiser
  let sessionManager: MPCSessionManager
  var foundPeers: [MCPeerID] = []
  
  init(serviceType: String, peerDisplayName: String)
  {
    peerID = MCPeerID(displayName: peerDisplayName)
    self.serviceType = serviceType
    browser = MCNearbyServiceBrowser(peer: peerID, serviceType: serviceType)
    advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: discoveryInfo, serviceType: serviceType)
    sessionManager = MPCSessionManager(peerID: peerID, encryptionPreference: .Required)
    
    super.init()
    browser.delegate = self
    advertiser.delegate = self
  }
  
  deinit
  {
    browser.stopBrowsingForPeers()
    advertiser.stopAdvertisingPeer()
  }
}

// MARK: - Advertiser
extension MPCManager: MCNearbyServiceAdvertiserDelegate {
  func advertiser(advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: NSData?, invitationHandler: (Bool, MCSession) -> Void)
  {
    print("Received invitation from: \(peerID)")
    invitationHandler(true, self.sessionManager.session)
  }
}

// MARK: - Browser
extension MPCManager: MCNearbyServiceBrowserDelegate {
  func browser(browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?)
  {
    foundPeers.append(peerID)
    print("Found peer: \(peerID)")
  }
  
  func browser(browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID)
  {
    if let index = foundPeers.indexOf(peerID) {
      foundPeers.removeAtIndex(index)
    }
    print("Lost peer: \(peerID)")
  }
}