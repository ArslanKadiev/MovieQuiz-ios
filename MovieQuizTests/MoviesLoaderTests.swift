//
//  MoviesLoaderTests.swift
//  MovieQuizTests
//
//  Created by Арслан Кадиев on 25.06.2023.
//

import XCTest
@testable import MovieQuiz

class MoviesLoaderTests: XCTestCase{
    
    func testSuccessLoading() throws{
        //given
        let loader = MoviesLoader()
        //when
        let expectation = expectation(description: "Loading expectation")
        loader.loadMovies{ result in
            switch result{
            case.success(let movies):
                expectation.fulfill()
            case.failure(_):
                XCTFail("Unexpected failure")
            }
            
        }
        
        waitForExpectations(timeout: 1)
        
    }
    
    func testFailureLoading() throws{
        //given
        //sleep(3)
        //when
        
        //then
        
    }
}
