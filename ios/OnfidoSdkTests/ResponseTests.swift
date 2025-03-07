//
//  ResponseTest.swift
//  OnfidoSdkTests
//
//  Created by Santana, Luis on 3/5/20.
//  Copyright © 2020 Onfido. All rights reserved.
//

import Foundation
import Onfido
import XCTest
@testable import OnfidoSdk

struct TestDocumentSideResult: ReactDocumentSideResult {
    let id: String
}

struct TestDocumentResult: ReactDocumentResult {
    let reactFront: ReactDocumentSideResult
    let reactBack: ReactDocumentSideResult?
}

struct TestFaceResult: ReactFaceResult {
    let id: String
}

class ResponseTests: XCTestCase {
    func testResponseOfSingleSidedDocumentCheck() {
        let documentResult = TestDocumentResult(
            reactFront: TestDocumentSideResult(id: "single-side-test"),
            reactBack: nil
        )

        let response = createResponse(document: documentResult)

        let document = response["document"]!
        let front = document["front"] as! [String: String]
        XCTAssertEqual(front["id"], "single-side-test")
        XCTAssertNil(document["back"])
        XCTAssertNil(response["face"])
    }

    func testResponseOfDoubleSidedDocumentCheck() {
        let documentResult = TestDocumentResult(
            reactFront: TestDocumentSideResult(id: "double-side-test-1"),
            reactBack: TestDocumentSideResult(id: "double-side-test-2")
        )

        let response = createResponse(document: documentResult)

        let document = response["document"]!
        let front = document["front"] as! [String: String]
        let back = document["back"] as! [String: String]
        XCTAssertEqual(front["id"], "double-side-test-1")
        XCTAssertEqual(back["id"], "double-side-test-2")
        XCTAssertNil(response["face"])
    }

    func testResponseOfFaceCheck() {
        let faceResult = TestFaceResult(id: "face-test")

        let response = createResponse(face: faceResult, faceVariant: "PHOTO")

        let face = response["face"] as! [String: String]
        XCTAssertEqual(face["id"], "face-test")
        XCTAssertEqual(face["variant"], "PHOTO")
        XCTAssertNil(response["document"])
    }
}
