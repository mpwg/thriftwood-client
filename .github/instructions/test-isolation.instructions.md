---
description: "Mandatory test isolation - no shared state between tests"
applyTo: "**/*Tests.swift"
---

# Test Isolation Rule

## Mandatory Rules

### Rule 1: No Shared State

**ALL TESTS MUST BE COMPLETELY ISOLATED FROM EACH OTHER. NO TEST SHALL SHARE STATE WITH ANY OTHER TEST.**

This is a **non-negotiable** requirement that ensures:

1. Tests can run in any order
2. Tests can run in parallel
3. Test failures are deterministic and reproducible
4. One test cannot affect another test's outcome

### Rule 2: Never Test Mocks

**MOCKS SHOULD NEVER HAVE LOGIC. YOU SHOULD NEVER TEST A MOCK, ONLY USE IT FOR TESTING OTHER STUFF.**

Mocks are test infrastructure. Testing them provides **ZERO value**:

- They don't test production code
- They just verify the mock behaves as you designed it
- If the mock is wrong, production might be broken but tests pass
- You waste time maintaining useless tests

## The Problem: Shared State

### ❌ ANTI-PATTERN: Shared Instance Variables

```swift
@Suite("Bad Test Suite")
struct BadTests {
    // ❌ WRONG: Shared instance variable across all tests
    var mockService: MockService

    init() {
        mockService = MockService()
    }

    @Test("Test 1")
    func test1() async throws {
        mockService.value = "test1"
        // This affects test2!
    }

    @Test("Test 2")
    func test2() async throws {
        // This test sees state from test1
        // Test order matters = BAD
    }
}
```

**Why This Is Bad:**

- Tests share the same `mockService` instance
- State from one test leaks into another
- Test execution order matters (WRONG!)
- Tests can fail randomly depending on execution order
- Parallel test execution is impossible

## The Solution: Factory Methods

### ✅ CORRECT PATTERN: Factory Methods for Fresh Instances

```swift
@Suite("Good Test Suite")
struct GoodTests {
    // ✅ CORRECT: Factory method creates fresh instance per test
    func makeMockService() -> MockService {
        return MockService()
    }

    @Test("Test 1")
    func test1() async throws {
        let mockService = makeMockService() // Fresh instance
        mockService.value = "test1"
        // Changes only affect this test
    }

    @Test("Test 2")
    func test2() async throws {
        let mockService = makeMockService() // Fresh instance
        // Clean state, independent of test1
    }
}
```

**Why This Is Good:**

- Each test gets a fresh instance
- No state leakage between tests
- Tests can run in any order
- Tests can run in parallel
- Failures are deterministic and reproducible

## Anti-Pattern: Testing Mocks

### ❌ WRONG: Tests That Test Mock Behavior

```swift
@Suite("Bad Example - Testing Mock")
struct RadarrServiceMovieTests {
    func makeMockService() -> MockRadarrService {
        return MockRadarrService()
    }

    @Test("Get movies returns empty list")
    func getMoviesEmpty() async throws {
        let mockService = makeMockService()
        // ❌ WRONG: Testing that mock returns empty when configured empty
        let movies = try await mockService.getMovies()
        #expect(movies.isEmpty)  // Testing mock, not production code!
    }

    @Test("Get movies returns populated list")
    func getMoviesPopulated() async throws {
        let mockService = makeMockService()
        mockService.movies = [
            Movie(id: 1, title: "Test Movie 1"),
            Movie(id: 2, title: "Test Movie 2"),
            Movie(id: 3, title: "Test Movie 3")
        ]

        // ❌ WRONG: Testing that mock returns what was set
        let movies = try await mockService.getMovies()
        #expect(movies.count == 3)  // Testing mock, not production code!
    }

    @Test("Add movie creates new movie with ID")
    func addMovie() async throws {
        let mockService = makeMockService()
        let movie = Movie(id: 0, title: "New Movie")

        // ❌ WRONG: Testing mock's add logic
        let added = try await mockService.addMovie(movie)
        #expect(added.id != 0)  // Testing mock's ID generation logic!
    }

    @Test("Mock service reset clears all state")
    func resetClearsState() async throws {
        let mockService = makeMockService()
        mockService.configureCallCount = 5
        mockService.movies = [Movie(id: 1, title: "Test")]

        // ❌ WRONG: Testing mock's reset logic
        mockService.reset()
        #expect(mockService.configureCallCount == 0)  // Testing mock infrastructure!
        #expect(mockService.movies.isEmpty)  // Testing mock infrastructure!
    }
}
```

**Why This Is Wrong:**

1. **Not testing production code** - These tests verify mock behavior, not app behavior
2. **Zero value** - They just confirm the mock works as designed
3. **False confidence** - If mock is buggy but matches expectations, tests pass while production is broken
4. **Wasted effort** - Time spent maintaining tests that don't catch real bugs
5. **Missing the point** - Mocks exist to test OTHER code, not to be tested themselves

### ✅ CORRECT: Using Mocks to Test Production Code

```swift
@Suite("ViewModel Tests - Good Example")
@MainActor
struct MovieViewModelTests {
    func makeMockService() -> MockRadarrService {
        return MockRadarrService()
    }

    func makeViewModel(service: RadarrServiceProtocol) -> MovieViewModel {
        return MovieViewModel(radarrService: service)
    }

    @Test("ViewModel loads movies on appear")
    func testLoadMovies() async throws {
        // Setup mock to return test data
        let mockService = makeMockService()
        mockService.moviesToReturn = [Movie(id: 1, title: "Test Movie")]

        // ✅ CORRECT: Testing ViewModel (production code), not the mock
        let viewModel = makeViewModel(service: mockService)
        await viewModel.onAppear()

        // Testing ViewModel behavior
        #expect(viewModel.movies.count == 1)
        #expect(viewModel.movies.first?.title == "Test Movie")
        #expect(viewModel.isLoading == false)
        #expect(mockService.getMoviesWasCalled == true)
    }

    @Test("ViewModel handles network errors gracefully")
    func testErrorHandling() async throws {
        // Setup mock to throw error
        let mockService = makeMockService()
        mockService.shouldThrowError = true
        mockService.errorToThrow = .networkError

        // ✅ CORRECT: Testing ViewModel error handling
        let viewModel = makeViewModel(service: mockService)
        await viewModel.loadMovies()

        // Testing ViewModel error state
        #expect(viewModel.error != nil)
        #expect(viewModel.movies.isEmpty)
        #expect(viewModel.showErrorAlert == true)
    }

    @Test("ViewModel filters movies by search text")
    func testSearchFiltering() async throws {
        let mockService = makeMockService()
        mockService.moviesToReturn = [
            Movie(id: 1, title: "Inception"),
            Movie(id: 2, title: "The Matrix"),
            Movie(id: 3, title: "Interstellar")
        ]

        // ✅ CORRECT: Testing ViewModel filtering logic
        let viewModel = makeViewModel(service: mockService)
        await viewModel.onAppear()

        viewModel.searchText = "Inter"

        // Testing ViewModel computed property
        #expect(viewModel.filteredMovies.count == 1)
        #expect(viewModel.filteredMovies.first?.title == "Interstellar")
    }
}
```

**Why This Is Correct:**

1. **Tests production code** - ViewModel is the code that ships
2. **Real value** - Catches bugs in business logic, state management, error handling
3. **True confidence** - If tests pass, ViewModel actually works correctly
4. **Proper use of mocks** - Mock provides controlled test data to exercise ViewModel

## Mock vs Fake: Know the Difference

### Mock

- **Purpose**: Verify interactions (was method called? with what arguments?)
- **Has logic**: NO - Just returns pre-configured values
- **When to use**: Testing that code calls dependencies correctly

```swift
final class MockRadarrService: RadarrServiceProtocol, @unchecked Sendable {
    var getMoviesWasCalled = false
    var getMoviesCallCount = 0
    var moviesToReturn: [Movie] = []

    func getMovies() async throws -> [Movie] {
        getMoviesWasCalled = true
        getMoviesCallCount += 1
        return moviesToReturn  // No logic, just return configured value
    }
}
```

### Fake

- **Purpose**: Simplified working implementation for testing
- **Has logic**: YES - Simplified version of real logic
- **When to use**: Integration testing or when real implementation is too complex

```swift
final class FakeRadarrService: RadarrServiceProtocol {
    private var movies: [Movie] = []
    private var nextID = 1

    func addMovie(_ movie: Movie) async throws -> Movie {
        var newMovie = movie
        newMovie.id = nextID  // Has logic: ID generation
        nextID += 1
        movies.append(newMovie)  // Has logic: state management
        return newMovie
    }

    func getMovies() async throws -> [Movie] {
        return movies  // Returns computed state
    }

    func deleteMovie(id: Int) async throws {
        movies.removeAll { $0.id == id }  // Has logic: filtering
    }
}
```

**CRITICAL**: If you have a Fake with logic, you might test the Fake itself with a few integration tests. But the PRIMARY use is to test production code that depends on the protocol.

## Implementation Guidelines

### Rule 1: No Instance Variables in Test Suites

**NEVER** declare instance variables in test suites unless they are:

- Immutable constants (`let`) that never change
- Simple values like URLs or strings used for test data
- NOT services, mocks, or any stateful objects

```swift
@Suite("Examples")
struct TestSuite {
    // ✅ OK: Immutable test data
    let testURL = URL(string: "https://test.com")!
    let testAPIKey = "test-key-12345"

    // ❌ WRONG: Mutable state
    var mockService: MockService
    var testData: [String]

    // ❌ WRONG: Even if initialized in init()
    let sharedService: SomeService
    init() {
        sharedService = SomeService() // Still shared!
    }
}
```

### Rule 2: Use Factory Methods

Create factory methods that return fresh instances:

```swift
// ✅ CORRECT: Factory method pattern
func makeTestService() throws -> ProfileService {
    let container = try ModelContainer.inMemoryContainer()
    let keychainService = MockKeychainService()
    let dataService = DataService(
        modelContainer: container,
        keychainService: keychainService
    )
    return ProfileService(dataService: dataService)
}

// Usage in tests:
@Test("My test")
func myTest() async throws {
    let service = try makeTestService() // Fresh for this test
    // Test logic here
}
```

### Rule 3: Create Instances at Test Method Level

Always create instances inside the test method, not at suite level:

```swift
@Test("Test with dependencies")
func testWithDependencies() async throws {
    // ✅ CORRECT: Create all dependencies inside test
    let mockData = MockDataService()
    let mockKeychain = MockKeychainService()
    let mockProfile = MockProfileService()

    let service = ServiceUnderTest(
        dataService: mockData,
        keychainService: mockKeychain,
        profileService: mockProfile
    )

    // Test logic
}
```

### Rule 4: In-Memory Storage for Integration Tests

When using real services (not mocks), use in-memory storage:

```swift
func makeTestDataService() throws -> DataService {
    // ✅ CORRECT: In-memory container = isolated storage
    let container = try ModelContainer.inMemoryContainer()
    let keychainService = MockKeychainService()
    return DataService(
        modelContainer: container,
        keychainService: keychainService
    )
}
```

**Never** use:

- Shared file system
- Shared database
- Shared global state
- Shared singletons

## Common Patterns

### Pattern 1: Mock Services

```swift
@Suite("Service Tests")
struct ServiceTests {
    func makeMockService() -> MockService {
        let mock = MockService()
        // Set default state if needed
        mock.resetToInitialState()
        return mock
    }

    @Test("Test case")
    func testCase() async throws {
        let service = makeMockService()
        // Test logic
    }
}
```

### Pattern 2: Real Services with In-Memory Storage

```swift
@Suite("Integration Tests")
struct IntegrationTests {
    func makeRealService() throws -> RealService {
        let container = try ModelContainer.inMemoryContainer()
        return RealService(container: container)
    }

    @Test("Integration test")
    func integrationTest() async throws {
        let service = try makeRealService()
        // Test logic
    }
}
```

### Pattern 3: Multiple Dependencies

```swift
@Suite("Complex Tests")
struct ComplexTests {
    func makeTestEnvironment() throws -> (
        service: ServiceUnderTest,
        mockData: MockDataService,
        mockKeychain: MockKeychainService
    ) {
        let mockData = MockDataService()
        let mockKeychain = MockKeychainService()
        let service = ServiceUnderTest(
            dataService: mockData,
            keychainService: mockKeychain
        )
        return (service, mockData, mockKeychain)
    }

    @Test("Complex test")
    func complexTest() async throws {
        let (service, mockData, mockKeychain) = try makeTestEnvironment()

        // Test logic with access to all components
    }
}
```

## Verification Checklist

Before committing test code, verify:

- [ ] No `var` instance variables in test suites (except immutable test data)
- [ ] All services/mocks created via factory methods
- [ ] Factory methods called inside each test method
- [ ] In-memory storage used for integration tests
- [ ] No global state or singletons
- [ ] Tests can run in any order
- [ ] Tests can run in parallel

## Running Tests to Verify Isolation

### Run Tests in Random Order

Swift Testing runs tests in parallel by default, which helps catch isolation issues:

```bash
# Run all tests (parallel execution tests isolation)
xcodebuild test -project Thriftwood.xcodeproj -scheme Thriftwood
```

### Run Individual Test Suites

```bash
# Run specific suite to verify it works in isolation
xcodebuild test -project Thriftwood.xcodeproj -scheme Thriftwood \
  -only-testing:ThriftwoodTests/MySuite
```

### Run Specific Test

```bash
# Run single test to verify it works independently
xcodebuild test -project Thriftwood.xcodeproj -scheme Thriftwood \
  -only-testing:ThriftwoodTests/MySuite/myTest
```

## Common Mistakes and Fixes

### Mistake 1: Shared Mock in Suite

```swift
// ❌ WRONG
@Suite
struct MyTests {
    var mock = MockService()

    @Test func test1() {
        mock.value = 1
    }
}
```

```swift
// ✅ FIX
@Suite
struct MyTests {
    func makeMock() -> MockService {
        return MockService()
    }

    @Test func test1() {
        let mock = makeMock()
        mock.value = 1
    }
}
```

### Mistake 2: Reusing Test Data

```swift
// ❌ WRONG
@Suite
struct MyTests {
    var testData = [1, 2, 3]

    @Test func test1() {
        testData.append(4) // Modifies shared data!
    }
}
```

```swift
// ✅ FIX
@Suite
struct MyTests {
    func makeTestData() -> [Int] {
        return [1, 2, 3]
    }

    @Test func test1() {
        var testData = makeTestData()
        testData.append(4) // Only affects this test
    }
}
```

### Mistake 3: Shared Database/File State

```swift
// ❌ WRONG
@Suite
struct MyTests {
    let dbPath = "/tmp/test.db"

    @Test func test1() {
        // Writes to shared file = pollution!
    }
}
```

```swift
// ✅ FIX
@Suite
struct MyTests {
    func makeInMemoryDB() throws -> ModelContainer {
        return try ModelContainer.inMemoryContainer()
    }

    @Test func test1() throws {
        let container = try makeInMemoryDB()
        // Isolated in-memory storage
    }
}
```

## Benefits of Test Isolation

1. **Deterministic Tests**: Same input = same output, always
2. **Parallel Execution**: Tests run faster with parallelization
3. **Order Independence**: Run tests in any order, get same results
4. **Easier Debugging**: Failures are reproducible and isolated
5. **Better CI/CD**: Reliable test runs in continuous integration
6. **Confidence**: Know your tests actually test what they claim

## Critical Rule: Never Test Mocks

### The Golden Rule

**MOCKS ARE TEST INFRASTRUCTURE. NEVER TEST THEM.**

If you find yourself writing tests like:

- "Mock returns what was set"
- "Mock tracks call counts correctly"
- "Mock's add/delete logic works"
- "Mock's reset clears state"

**STOP.** These tests have **ZERO value** and should be **DELETED**.

### What to Test Instead

✅ **DO TEST**:

- ViewModels using mocks
- Coordinators using mocks
- Services using mocks
- Business logic using mocks
- Real implementations with integration tests

❌ **DON'T TEST**:

- That mocks return configured values
- That mocks track calls correctly
- Mock internal logic
- Mock state management
- Test infrastructure itself

### Example: What to Delete

If your test suite has tests like these, **DELETE THEM**:

```swift
// ❌ DELETE THIS - Testing mock
@Test("Get movies returns empty list")
func getMoviesEmpty() async throws {
    let mock = makeMockService()
    let result = try await mock.getMovies()
    #expect(result.isEmpty)  // Just testing mock returns empty!
}

// ❌ DELETE THIS - Testing mock call tracking
@Test("Mock service reset clears all state")
func resetClearsState() async throws {
    let mock = makeMockService()
    mock.configureCallCount = 5
    mock.reset()
    #expect(mock.configureCallCount == 0)  // Testing mock infrastructure!
}
```

### Example: What to Keep/Add

Keep or add tests that use mocks to test production code:

```swift
// ✅ KEEP THIS - Testing ViewModel
@Test("ViewModel loads movies on appear")
func testViewModelLoads() async throws {
    let mock = makeMockService()
    mock.moviesToReturn = [Movie(id: 1, title: "Test")]

    let viewModel = MovieViewModel(service: mock)
    await viewModel.onAppear()

    #expect(viewModel.movies.count == 1)  // Testing ViewModel, not mock!
}
```

## Enforcement

### SwiftLint Rule

While SwiftLint cannot fully enforce test isolation, we check:

- No warnings for test-specific code
- Follow all other code quality rules

### Code Review

All test code MUST be reviewed for:

- [ ] No shared state between tests
- [ ] Proper use of factory methods
- [ ] Correct isolation patterns
- [ ] **Tests use mocks, not test mocks themselves**
- [ ] **No tests that verify mock behavior**
- [ ] **All tests exercise production code**

### CI/CD

Tests run in parallel in CI, which will catch most isolation issues:

- Flaky tests = likely isolation problem
- Random failures = check for shared state

## Examples in Codebase

### Good Examples

- `ProfileServiceTests.swift` - Uses `makeTestService()` factory
- `UserPreferencesServiceTests.swift` - Uses `makeMockPreferencesService()`
- `DataServiceTests.swift` - In-memory containers per test
- `CoordinatorTests.swift` - Mocks used to test coordinator navigation logic

### Bad Examples (Need Fixing)

- ❌ `RadarrServiceTests.swift` - Multiple test suites that test MockRadarrService behavior:
  - `RadarrServiceMovieTests` - Tests mock's movie CRUD logic (DELETE)
  - `RadarrServiceCallTrackingTests` - Tests mock's call tracking (DELETE)
  - `RadarrServiceConfigurationResourcesTests` - Tests mock's profile management (DELETE)
  - `RadarrServiceSystemInfoTests` - Tests mock's system info logic (DELETE)
  - `RadarrServiceErrorHandlingTests` - Tests mock's error simulation (DELETE)
  - `RadarrServiceConcurrentOperationsTests` - Tests mock's concurrency (DELETE)

**Action Required**: Delete these 6 test suites. They provide zero value. Add new tests that use MockRadarrService to test ViewModels or Coordinators instead.

### Fixed Examples

- ✅ `RadarrServiceTests.swift` - Converted shared instances to factory methods (test isolation fixed)
- ✅ `KeychainServiceTests.swift` - Converted shared instance to factory method

## Resources

- [Swift Testing Documentation](https://developer.apple.com/documentation/testing)
- [Test Isolation Best Practices](https://developer.apple.com/documentation/xcode/running-tests-and-interpreting-results)
- Project Tests: `/ThriftwoodTests/` - See examples

---

**Remember**: Isolated tests = Reliable tests = Confident deploys = Happy developers! 🎉
