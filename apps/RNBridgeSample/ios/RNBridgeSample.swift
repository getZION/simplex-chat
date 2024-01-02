//
//  RNBridgeSample.swift
//  RNBridgeSample
//
//  Created by Andor Kesselman on 1/2/24.
//

import Foundation
import SimpleXChat

@objc(RNBridgeSample)
class RNBridgeSample: NSObject {
  private var count = 0

  @objc
  func increment() {
    count += 1
    print("count is \(count)")
  }

  @objc
  func getCount(_ callback: RCTResponseSenderBlock) {
    callback([count])
  }

  @objc
  func constantsToExport() -> [AnyHashable : Any]! {
    return [
      "number": 123.9,
      "string": "foo",
      "boolean": true,
      "array": [1, 22.2, "33"],
      "object": ["a": 1, "b": 2]
    ]
  }

  @objc
  static func requiresMainQueueSetup() -> Bool {
    return true
  }

  @objc
  func helloSimplex() -> String {
    print("Hello Simplex!")
    let api = SimpleXAPI()
    print("created api")
    return api.apiGetVersion()
  }

}
