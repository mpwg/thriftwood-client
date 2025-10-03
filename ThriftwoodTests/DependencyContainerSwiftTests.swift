//
//  DependencyContainerSwiftTests.swift
//  ThriftwoodTests
//
//  Unit tests for dependency injection container using Swift Testing
//

import Testing
@testable import Thriftwood

@Suite("Dependency Container Tests")
struct DependencyContainerSwiftTests {
    
    // MARK: - Singleton Registration Tests
    
    @Test("Register singleton with explicit type")
    func registerSingleton() throws {
        // Given
        let container = DependencyContainer()
        let testString = "Test Service"
        
        // When
        container.register(String.self, instance: testString)
        
        // Then
        let resolved = try container.resolve(String.self)
        #expect(resolved == testString)
    }
    
    @Test("Register singleton with type inference")
    func registerSingletonWithTypeInference() throws {
        // Given
        let container = DependencyContainer()
        let testNumber = 42
        
        // When
        container.register(testNumber)
        
        // Then
        let resolved = try container.resolve(Int.self)
        #expect(resolved == testNumber)
    }
    
    @Test("Singleton returns same instance")
    func singletonReturnsSameInstance() throws {
        // Given
        let container = DependencyContainer()
        class TestClass {
            let id = UUID()
        }
        let instance = TestClass()
        container.register(TestClass.self, instance: instance)
        
        // When
        let resolved1 = try container.resolve(TestClass.self)
        let resolved2 = try container.resolve(TestClass.self)
        
        // Then
        #expect(resolved1 === instance)
        #expect(resolved2 === instance)
        #expect(resolved1.id == resolved2.id)
    }
    
    // MARK: - Factory Registration Tests
    
    @Test("Register factory creates new instances")
    func registerFactory() throws {
        // Given
        let container = DependencyContainer()
        var callCount = 0
        container.register(String.self) {
            callCount += 1
            return "Instance \(callCount)"
        }
        
        // When
        let instance1 = try container.resolve(String.self)
        let instance2 = try container.resolve(String.self)
        
        // Then
        #expect(instance1 == "Instance 1")
        #expect(instance2 == "Instance 2")
        #expect(callCount == 2)
    }
    
    // MARK: - Resolution Tests
    
    @Test("Resolve throws for unregistered type")
    func resolveThrowsForUnregistered() {
        // Given
        let container = DependencyContainer()
        
        // When/Then
        #expect(throws: DependencyError.self) {
            try container.resolve(String.self)
        }
    }
    
    @Test("Resolve optional returns nil for unregistered type")
    func resolveOptionalReturnsNilForUnregistered() {
        // Given
        let container = DependencyContainer()
        
        // When
        let result = container.resolveOptional(String.self)
        
        // Then
        #expect(result == nil)
    }
    
    @Test("Resolve optional returns instance when registered")
    func resolveOptionalReturnsInstanceWhenRegistered() throws {
        // Given
        let container = DependencyContainer()
        container.register("Test")
        
        // When
        let result = container.resolveOptional(String.self)
        
        // Then
        #expect(result != nil)
        #expect(result == "Test")
    }
    
    // MARK: - Unregister Tests
    
    @Test("Unregister removes registration")
    func unregister() throws {
        // Given
        let container = DependencyContainer()
        container.register("Test")
        let resolved = try container.resolve(String.self)
        #expect(resolved == "Test")
        
        // When
        container.unregister(String.self)
        
        // Then
        #expect(throws: DependencyError.self) {
            try container.resolve(String.self)
        }
    }
    
    // MARK: - Reset Tests
    
    @Test("Reset clears all registrations")
    func reset() throws {
        // Given
        let container = DependencyContainer()
        container.register("String Test")
        container.register(42)
        
        // When
        container.reset()
        
        // Then
        #expect(throws: DependencyError.self) {
            try container.resolve(String.self)
        }
        #expect(throws: DependencyError.self) {
            try container.resolve(Int.self)
        }
    }
    
    // MARK: - Thread Safety Tests
    
    @Test("Concurrent registration and resolution")
    func threadSafety() async throws {
        // Given
        let container = DependencyContainer()
        let iterations = 100
        
        // When - Register and resolve concurrently
        await withTaskGroup(of: Void.self) { group in
            for i in 0..<iterations {
                group.addTask {
                    container.register(String.self, instance: "Value \(i)")
                }
                
                group.addTask {
                    _ = try? container.resolve(String.self)
                }
            }
        }
        
        // Then - Should not crash and should have a registered value
        let result = try? container.resolve(String.self)
        #expect(result != nil)
    }
}
