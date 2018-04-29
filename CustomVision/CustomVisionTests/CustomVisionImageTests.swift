//
//  CustomVisionImageTests.swift
//  CustomVision
//
//  Created by Colby L Williams on 4/27/18.
//

import XCTest
@testable import CustomVision

class CustomVisionImageTests: XCTestCase {
    
    let timeout: TimeInterval = 30.0
    
    var trainingKey: String!
    var projectId: String!
    var iterationId: String? = nil
    var tagIds: [String] = []
    
    let client = CustomVisionClient.shared
    
    override func setUp() {
        super.setUp()
        
        // trainingKey =
        // projectId =
        // iterationId =
        // tagIds = []
        
        
        CustomVisionClient.defaultProjectId = projectId
        
        client.trainingKey = trainingKey
    }
    
    
    func testAddImageFromUIImageAndCreateTag() {
        
        var response: CustomVisionResponse<ImageCreateSummary>?
        let expectation = self.expectation(description: "should not fail :)")
        
        let testImage = UIImage(named: "earring", in: Bundle(for: type(of: self)), compatibleWith: nil)
        
        XCTAssertNotNil(testImage)
        
        guard let earring = testImage else { return }
        
        client.createImage(from: earring, withNewTagNamed: "TestTest") { r in
            r.printResponseData()
            r.printResult()
            response = r
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: timeout)
        
        XCTAssertNotNil(response?.response)
        XCTAssertTrue(response!.result.isSuccess)
        XCTAssertNotNil(response!.response)
        XCTAssertNil(response!.error)
    }
    
    
    func testAddImageFromImageFileCreateBatch() {
        
        var response: CustomVisionResponse<ImageCreateSummary>?
        let expectation = self.expectation(description: "should not fail :)")
        
        let testImage = UIImage(named: "earring", in: Bundle(for: type(of: self)), compatibleWith: nil)
        
        XCTAssertNotNil(testImage)
        
        guard let earring = testImage else { return }
        
        let imageData = UIImagePNGRepresentation(earring)
        
        let entry = ImageFileCreateEntry(Name: nil, Contents: imageData, TagIds: tagIds)
        let batch = ImageFileCreateBatch(Images: [entry], TagIds: nil)
        
        client.createImages(from: batch) { r in
            r.printResponseData()
            r.printResult()
            response = r
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: timeout)
        
        XCTAssertNotNil(response?.response)
        XCTAssertTrue(response!.result.isSuccess)
        XCTAssertNotNil(response!.response)
        XCTAssertNil(response!.error)
    }
    
    
    
    func testGetTaggedImagesWithTag() {
        
        var response: CustomVisionResponse<[Image]>?
        let expectation = self.expectation(description: "should not fail :)")

        client.getTaggedImages(withTags: tagIds) { r in
            r.printResponseData()
            r.printResult()
            response = r
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: timeout)
        
        XCTAssertNotNil(response?.response)
        XCTAssertTrue(response?.resource?.count ?? 6 < 6)
        XCTAssertTrue(response!.result.isSuccess)
        XCTAssertNotNil(response!.response)
        XCTAssertNil(response!.error)
    }

    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    //    func testPerformanceExample() {
    //        // This is an example of a performance test case.
    //        self.measure {
    //            // Put the code you want to measure the time of here.
    //        }
    //    }
}
