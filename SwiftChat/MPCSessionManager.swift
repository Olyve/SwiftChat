//
//  MPCSessionManager.swift
//  SwiftChat
//
//  Created by Sam Galizia on 7/21/16.
//  Copyright © 2016 Chexology. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class MPCSessionManager: NSObject, MCSessionDelegate {
  var peerID: MCPeerID
  var session: MCSession
  
  init(peerID: MCPeerID, encryptionPreference: MCEncryptionPreference)
  {
    self.peerID = peerID
    self.session = MCSession(peer: self.peerID, securityIdentity: nil, encryptionPreference: .Required)
  }
  
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
