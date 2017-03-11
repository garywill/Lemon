//
//  OAuthTests.swift
//  Lemon
//
//  Created by X140Yu on 3/10/17.
//  Copyright © 2017 X140Yu. All rights reserved.
//

import XCTest
@testable import Lemon

class OAuthTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test_decodeCallbackURL() {
        let successTestCases = ["lemon://oauth/github?code=123123": "123123",
                         "lemon://oauth/github?code=asdjklqwe&coda=asdjkla": "asdjklqwe"]
        successTestCases.forEach { (URLString, code) in
            if let url = URL(string: URLString) {
                if let code = OAuthHelper.decode("code", url.absoluteString) {
                    XCTAssertEqual(code, successTestCases[URLString])
                }
            }
        }
        let wrongCases = ["lemon://oauth/github?cc=asd",
                          "lll://asdkla"]
        wrongCases.forEach { URLString in
            if let url = URL(string: URLString) {
                let code = OAuthHelper.decode("code", url.absoluteString)
                XCTAssertNil(code)
            }
        }
        
    }

}
