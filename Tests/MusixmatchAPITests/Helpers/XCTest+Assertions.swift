//
//  File.swift
//  
//
//  Created by Greener Chen on 2024/9/16.
//

import XCTest

func XCTAssertAsyncThrowError<T>(_ expression: @autoclosure () async throws -> T,
                                 _ message: @autoclosure () -> String = "",
                                 file: StaticString = #filePath,
                                 line: UInt = #line,
                                 _ errorHandler: (Error) -> Void = { _ in }) async {
    do {
        _ = try await expression()
        XCTFail("Expected to throw an error", file: file, line: line)
    } catch {
        errorHandler(error)
    }
}

func XCTAssertAsyncThrowNoError<T>(_ expression: @autoclosure () async throws -> T,
                                 _ message: @autoclosure () -> String = "",
                                 file: StaticString = #filePath,
                                 line: UInt = #line,
                                 _ errorHandler: (Error) -> Void = { _ in }) async {
    do {
        _ = try await expression()
    } catch {
        errorHandler(error)
        XCTFail("Expected to throw no error", file: file, line: line)
    }
}
