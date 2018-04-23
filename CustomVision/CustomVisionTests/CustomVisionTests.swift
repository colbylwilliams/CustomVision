//
//  CustomVisionTests.swift
//  CustomVisionTests
//
//  Created by Colby L Williams on 4/14/18.
//

import XCTest
@testable import CustomVision

class CustomVisionTests: XCTestCase {
    
    let timeout: TimeInterval = 30.0
    
    let projectId = ""
    let iterationId: String? = nil
    
    let client = CustomVisionClient(withTrainingKey: "")
    
    override func setUp() {
        super.setUp()
        
        CustomVisionClient.defaultProjectId = projectId
    }
    
    
    func testGetProjects () {
        
        var response: CustomVisionResponse<[Project]>?
        let expectation = self.expectation(description: "should not fail :)")

        client.getProjects { r in
            //r.printResponseData()
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

    func testGetProject () {
        
        var response: CustomVisionResponse<Project>?
        let expectation = self.expectation(description: "should not fail :)")

        client.getProject { r in
            //r.printResponseData()
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

    func testGetProjectWithId () {
        
        var response: CustomVisionResponse<Project>?
        let expectation = self.expectation(description: "should not fail :)")
        
        client.getProject(withId: projectId) { r in
            //r.printResponseData()
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

    func testGetIterations () {
        
        var response: CustomVisionResponse<[Iteration]>?
        let expectation = self.expectation(description: "should not fail :)")

        client.getIterations { r in
            //r.printResponseData()
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

    func testGetIterationsInProject () {
        
        var response: CustomVisionResponse<[Iteration]>?
        let expectation = self.expectation(description: "should not fail :)")
        
        client.getIterations(inProject: projectId) { r in
            //r.printResponseData()
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
    
    func testGetIteration () {
        
        XCTAssertNotNil(iterationId)
        
        guard let iterationId = iterationId else { return }
        
        var response: CustomVisionResponse<Iteration>?
        let expectation = self.expectation(description: "should not fail :)")
        
        client.getIteration(withId: iterationId) { r in
            //r.printResponseData()
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
    
    func testGetIterationInProject () {
        
        XCTAssertNotNil(iterationId)

        guard let iterationId = iterationId else { return }
        
        var response: CustomVisionResponse<Iteration>?
        let expectation = self.expectation(description: "should not fail :)")
        
        client.getIteration(inProject: projectId, withId: iterationId) { r in
            //r.printResponseData()
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
    
    func testGetAccountInfo () {
        
        var response: CustomVisionResponse<Account>?
        let expectation = self.expectation(description: "should not fail :)")
        
        client.getAccountInfo { r in
            //r.printResponseData()
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
