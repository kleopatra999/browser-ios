/* This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import Foundation
import XCTest
@testable import Client
import Shared

class NicewareTest: XCTestCase {
    
    func testNewByteSeed() {
        let niceware = Niceware()
        let byteCount = 8
        let expect = self.expectationWithDescription("newPassphrase attempt")
        
        niceware.uniqueBytes(count: byteCount) { (result, error) in
            XCTAssertNil(error, "new passphrase contained error")
            XCTAssertNotNil(result, "new passphrase result was nil")
            // Force unwrapping only okay since this is a unit test
            XCTAssertEqual(result!.count, byteCount)
            
            expect.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(4) { error in
            XCTAssertNil(error, "Niceware new passphrase error")
        }
    }
    
    func testPassphraseToByte() {
        let niceware = Niceware()
        
        let expect = self.expectationWithDescription("passphraseToByte attempt")

        let input = ["administrational","experimental","disconnection","plane","gigaton","savaging","wheaten","suez","herman","retina","bailment","gorier","overmodestly","idealism","mesa","theurgy",]
        let expectedOut = [0x00, 0xee, 0x4a, 0x42, 0x3a, 0xa3, 0xa3, 0x0f, 0x59, 0x5f, 0xc2, 0x00, 0xfa, 0x6a, 0xd9, 0xc9, 0x63, 0x38, 0xbb, 0x02, 0x0c, 0x37, 0x5b, 0x92, 0x98, 0xe7, 0x68, 0x79, 0x84, 0xba, 0xe1, 0x9f]
        
        niceware.bytes(fromPassphrase: input) { (result, error) in
            XCTAssertNil(error, "passphraseToByte contained error")
            XCTAssertNotNil(result, "passphraseToByte result was nil")
            
            guard let result = result else {
                XCTAssertNotNil(false, "passphrase cast to [String] failed")
                return
            }
            
            XCTAssertEqual(result, expectedOut)
            
            expect.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(4) { error in
            XCTAssertNil(error, "Niceware error with `bytes`")
        }
        
    }
    
    func testByteToPassphrase() {
        let niceware = Niceware()
        
        let expect = self.expectationWithDescription("byteToPassphrase attempt")
        niceware.passphrase(fromBytes: ["00", "ee", "4a", "42", "3a", "a3", "a3", "0f", "59", "5f", "c2", "00", "fa", "6a", "d9", "c9", "63", "38", "bb", "02", "0c", "37", "5b", "92", "98", "e7", "68", "79", "84", "ba", "e1", "9f"]) { (result, error) in
            XCTAssertNil(error, "byteToPassphrase contained error")
            XCTAssertNotNil(result, "byteToPassphrase result was nil")
            
            guard let resultWithStrings = result as? [String] else {
                XCTAssert(false, "byteToPassphrase cast to [String] failed")
                return
            }
            
            XCTAssertEqual(resultWithStrings, ["administrational","experimental","disconnection","plane","gigaton","savaging","wheaten","suez","herman","retina","bailment","gorier","overmodestly","idealism","mesa","theurgy",])
            
            expect.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(4) { error in
            XCTAssertNil(error, "Niceware error with `passphrase`")
        }
    }
}