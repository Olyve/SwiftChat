//
//  ViewControllerTests.swift
//  SwiftChat
//
//  Created by chexology on 7/15/16.
//  Copyright (c) 2016 Chexology. All rights reserved.
//

@testable import SwiftChat
import XCTest

class ViewControllerTests: XCTestCase {
  let viewController = ViewController()
  
  override func setUp()
  {
    super.setUp()
    
    viewController.loadViewIfNeeded()
  }
  
}

// MARK: Tests
extension ViewControllerTests {
  func test_shouldAdvertiseUpdates_whenSwitchValueChanges()
  {
    viewController.advertiseSwitch.on = true
    
    XCTAssertEqual(viewController.advertiseSwitch.on, viewController.shouldAdvertise)
  }
}