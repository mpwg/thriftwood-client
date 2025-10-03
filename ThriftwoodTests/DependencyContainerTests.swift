//
//  DependencyContainerTests.swift
//  ThriftwoodTests
//
//  Unit tests for dependency injection container
//

import XCTest
@testable import Thriftwood

final class DependencyContainerTests: XCTestCase {
    
    var container: DependencyContainer!
    
    override func setUp() {
        super.setUp()
        container = DependencyContainer.shared
        container.reset()
    }
    
    override func tearDown() {
        container.reset()
        super.tearDown()
    }
    
    // MARK: - Singleton Registration Tests
    
    func testRegisterSingleton() throws {
        // Given
        let testString = "Test Service"
        
        // When
        container.register(String.self, instance: testString)
        
        // Then
        let resolved = try container.resolve(String.self)
        XCTAssertEqual(resolved, testString)
    }
    
    func testRegisterSingletonWithTypeInference() throws {
        // Given
        let testNumber = 42
        
        // When
        container.register(testNumber)
        
        // Then
        let resolved = try container.resolve(Int.self)
        XCTAssertEqual(resolved, testNumber)
    }
    
    func testSingletonReturnsSameInstance() throws {
        // Given
        class TestClass {
            let id = UUID()
        }
        let instance = TestClass()
        container.register(TestClass.self, instance: instance)
        
        // When
        let resolved1 = try container.resolve(TestClass.self)
        let resolved2 = try container.resolve(TestClass.self)
        
        // Then
        XCTAssertTrue(resolved1 === instance)
        XCTAssertTrue(resolved2 === instance)
        XCTAssertEqual(resolved1.id, resolved2.id)
    }
    
    // MARK: - Factory Registration Tests
    
    func testRegisterFactory() throws {
        // Given
        var callCount = 0
        container.register(String.self) {
            callCount += 1
            return "Instance \(callCount)"
        }
        
        // When
        let instance1 = try container.resolve(String.self)
        let instance2 = try container.resolve(String.self)
        
        // Then
        XCTAssertEqual(instance1, "Instance 1")
        XCTAssertEqual(instance2, "Instance 2")
        XCTAssertEqual(callCount, 2)
    }
    
    // MARK: - Resolution Tests
    
    func testResolveThrowsForUnregistered() {
        // Given/When/Then
        XCTAssertThrowsError(try container.resolve(String.self)) { error in
            XCTAssertTrue(error is DependencyError)
        }
    }
    
    func testResolveOptionalReturnsNilForUnregistered() {
        // Given/When
        let result = container.resolveOptional(String.self)
        
        // Then
        XCTAssertNil(result)
    }
    
    func testResolveOptionalReturnsInstanceWhenRegistered() throws {
        // Given
        container.register("Test")
        
        // When
        let result = container.resolveOptional(String.self)
        
        // Then
        XCTAssertNotNil(result)
        XCTAssertEqual(result, "Test")
    }
    
    // MARK: - Unregister Tests
    
    func testUnregister() throws {
        // Given
        container.register("Test")
        let resolved = try container.resolve(String.self)
        XCTAssertEqual(resolved, "Test")
        
        // When
        container.unregister(String.self)
        
        // Then
        XCTAssertThrowsError(try container.resolve(String.self))
    }
    
    // MARK: - Reset Tests
    
    func testReset() throws {
        // Given
        container.register("String Test")
        container.register(42)
        
        // When
        container.reset()
        
        // Then
        XCTAssertThrowsError(try container.resolve(String.self))
        XCTAssertThrowsError(try container.resolve(Int.self))
    }
    
    // MARK: - Thread Safety Tests
    
    func testThreadSafety() async throws {
        // Given
        let iterations = 100
        
        // When - Register and resolve concurrently
        await withTaskGroup(of: Void.self) { group in
            for i in 0..<iterations {
                group.addTask {
                    self.container.register(String.self, instance: "Value \(i)")
                }
                
                group.addTask {
                    _ = try? self.container.resolve(String.self)
                }
            }
        }
        
        // Then - Should not crash
        XCTAssertNoThrow(try container.resolve(String.self))
    }
}
