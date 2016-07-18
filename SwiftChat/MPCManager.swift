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
  var foundPeers: [MCPeerID]!
  var browser: MCNearbyServiceBrowser!
  var advertiser: MCNearbyServiceAdvertiser!
  var peerID: MCPeerID = MCPeerID(displayName: UIDevice.currentDevice().name) // In production this could be the kiosk number or UUID
  var discoveryInfo: [String : String]? = nil
  var serviceType = "swift-chat"
  var session: MCSession?
  
  static let sharedInstance = MPCManager()
  
  private override init()
  {
    super.init()
    
    foundPeers = []
    session = MCSession(peer: peerID)
    session?.delegate = self
    browser = MCNearbyServiceBrowser(peer: peerID, serviceType: serviceType)
    browser.delegate = self
    advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: discoveryInfo, serviceType: serviceType)
    advertiser.delegate = self
  }
  
  deinit
  {
    browser.stopBrowsingForPeers()
    advertiser.stopAdvertisingPeer()
  }
}

// MARK: - MCNearbyServiceAdvertiserDelegate
extension MPCManager: MCNearbyServiceAdvertiserDelegate {
  func advertiser(advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: NSData?, invitationHandler: (Bool, MCSession) -> Void)
  {
    print("Received invitation from: \(peerID)")
  }
}

// MARK: - MCNearbyServiceBrowserDelegate
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

// MARK: - MCSessionDelegate
extension MPCManager: MCSessionDelegate {
  func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState)
  {
    switch state {
    case .NotConnected:
      print("Not Connected to: \(peerID)")
    case .Connecting:
      print("Connecting to: \(peerID)")
    case .Connected:
      print("Connected to: \(peerID)")
    }
  }
  
  func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID)
  {
    print("didReceiveData")
  }
  
  func session(session: MCSession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MCPeerID)
  {
    print("didReceiveStream")
  }
  
  func session(session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, withProgress progress: NSProgress)
  {
    print("didStartreceivingResourceWithName")
  }
  
  func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?)
  {
    print("didFinishReceivingResourceWithName")
  }
}