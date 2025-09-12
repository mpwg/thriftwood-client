import Combine
import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()
    @EnvironmentObject var container: DIContainer
    @EnvironmentObject var coordinator: AppCoordinator

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    headerSection
                    modulesSection
                }
                .padding()
            }
            .navigationTitle("Dashboard")
            .refreshable {
                await viewModel.refreshData()
            }
            .task {
                await viewModel.loadData()
            }
            .alert("Error", isPresented: .constant(viewModel.error != nil)) {
                Button("OK") {
                    viewModel.clearError()
                }
            } message: {
                Text(viewModel.error?.localizedDescription ?? "Unknown error")
            }
        }
        .onAppear {
            Task {
                await viewModel.onViewAppear()
            }
        }
        .onDisappear {
            viewModel.onViewDisappear()
        }
    }

    @ViewBuilder
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(viewModel.dashboardData?.title ?? "Loading...")
                .font(.largeTitle)
                .fontWeight(.bold)

            if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(0.8)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    private var modulesSection: some View {
        if let modules = viewModel.dashboardData?.modules {
            LazyVGrid(columns: adaptiveColumns, spacing: 16) {
                ForEach(modules) { module in
                    ModuleCard(module: module) {
                        coordinator.navigate(to: .moduleDetail(module.name))
                    }
                }
            }
        }
    }

    private var adaptiveColumns: [GridItem] {
        [
            GridItem(.adaptive(minimum: 160, maximum: 200), spacing: 16)
        ]
    }
}

struct ModuleCard: View {
    let module: DashboardModule
    let onTap: () -> Void

    var body: some View {
        Button {
            onTap()
        } label: {
            VStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(module.isEnabled ? Color.blue : Color.gray)
                    .frame(height: 80)
                    .overlay(
                        Text(module.name.prefix(1).uppercased())
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    )

                VStack(spacing: 4) {
                    Text(module.name)
                        .font(.headline)
                        .lineLimit(1)

                    Text(module.isEnabled ? "Enabled" : "Disabled")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(16)
            .background(Color.primary.colorInvert())
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }
}

@MainActor
final class DashboardViewModel: BaseViewModel {
    @Published var dashboardData: DashboardData?

    private var repository: DashboardRepository?

    override init() {
        super.init()
    }

    override func onViewAppear() async {
        if repository == nil {
            // Lazy initialization of repository
            repository = DIContainer.shared.resolve(DashboardRepository.self)
        }
        await loadData()
    }

    func loadData() async {
        guard let repository = repository else { return }

        do {
            let data = try await withLoading {
                try await repository.fetchDashboardData()
            }
            dashboardData = data
        } catch {
            // Error is already set by withLoading
            print("Failed to load dashboard data: \(error)")
        }
    }

    func refreshData() async {
        await loadData()
    }
}

#if DEBUG
    #Preview {
        DashboardView()
            .environmentObject(DIContainer.shared)
            .environmentObject(AppCoordinator(container: DIContainer.shared))
    }
#endif
