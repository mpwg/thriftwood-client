# Milestone 2: Service Integration - Phase 1

**Duration**: Weeks 4-6  
**Goal**: Implement Radarr and Sonarr services  
**Deliverable**: Working movie and TV show management

## Week 4: Radarr Service Implementation

### Task 4.1: Radarr API Client

**Estimated Time**: 8 hours

- [ ] Create RadarrService protocol
- [ ] Implement authentication handling
- [ ] Create endpoint definitions
- [ ] Implement response models
- [ ] Add error handling specific to Radarr

### Task 4.2: Radarr Data Models

**Estimated Time**: 6 hours

- [ ] Define Movie model
- [ ] Create Quality Profile models
- [ ] Implement Root Folder models
- [ ] Add Release models
- [ ] Create System Status models

### Task 4.3: Radarr Repository

**Estimated Time**: 6 hours

- [ ] Implement movie fetching (all, single, search)
- [ ] Add movie management (add, edit, delete)
- [ ] Create quality profile management
- [ ] Implement root folder operations
- [ ] Add system/health monitoring

### Task 4.4: Radarr ViewModels

**Estimated Time**: 8 hours

- [ ] Create MoviesListViewModel
- [ ] Implement MovieDetailViewModel
- [ ] Build AddMovieViewModel
- [ ] Create MovieSearchViewModel
- [ ] Add RadarrSettingsViewModel

## Week 5: Radarr UI & Sonarr Service

### Task 5.1: Radarr UI Views

**Estimated Time**: 10 hours

- [ ] Build MoviesListView with grid/list toggle
- [ ] Create MovieDetailView with metadata
- [ ] Implement AddMovieView with search
- [ ] Add MovieCardView component
- [ ] Create RadarrSettingsView

### Task 5.2: Sonarr API Client

**Estimated Time**: 8 hours

- [ ] Create SonarrService protocol
- [ ] Implement authentication handling
- [ ] Create endpoint definitions
- [ ] Implement response models
- [ ] Add error handling specific to Sonarr

### Task 5.3: Sonarr Data Models

**Estimated Time**: 6 hours

- [ ] Define Series model
- [ ] Create Season/Episode models
- [ ] Implement Quality Profile models
- [ ] Add Release models
- [ ] Create Calendar models

## Week 6: Sonarr UI & Integration

### Task 6.1: Sonarr Repository

**Estimated Time**: 6 hours

- [ ] Implement series fetching
- [ ] Add series management operations
- [ ] Create season/episode operations
- [ ] Implement calendar functionality
- [ ] Add wanted/missing episodes

### Task 6.2: Sonarr ViewModels

**Estimated Time**: 8 hours

- [ ] Create SeriesListViewModel
- [ ] Implement SeriesDetailViewModel
- [ ] Build AddSeriesViewModel
- [ ] Create CalendarViewModel
- [ ] Add SonarrSettingsViewModel

### Task 6.3: Sonarr UI Views

**Estimated Time**: 10 hours

- [ ] Build SeriesListView
- [ ] Create SeriesDetailView with seasons
- [ ] Implement AddSeriesView
- [ ] Add EpisodeView component
- [ ] Create CalendarView

### Task 6.4: Shared Components

**Estimated Time**: 6 hours

- [ ] Create MediaCardView (movies/series)
- [ ] Build QualityBadgeView
- [ ] Implement StatusIndicatorView
- [ ] Add MediaSearchBar
- [ ] Create MediaFilterView

## Testing & Integration

### Task T2: Service Tests

**Estimated Time**: 8 hours

- [ ] Test Radarr API client
- [ ] Test Sonarr API client
- [ ] Mock service responses
- [ ] Test error scenarios
- [ ] Verify data parsing

### Task I1: Integration Testing

**Estimated Time**: 6 hours

- [ ] Test with live Radarr instance
- [ ] Test with live Sonarr instance
- [ ] Verify all CRUD operations
- [ ] Test error recovery
- [ ] Performance testing

## Acceptance Criteria

### Functional Criteria

- [ ] Can configure Radarr connection
- [ ] Can browse and search movies
- [ ] Can add/edit/delete movies
- [ ] Can configure Sonarr connection
- [ ] Can browse and search series
- [ ] Can add/edit/delete series
- [ ] Calendar view works

### Technical Criteria

- [ ] API calls are efficient
- [ ] Proper error handling
- [ ] Loading states implemented
- [ ] Offline mode works
- [ ] > 70% test coverage

## UI/UX Requirements

### List Views

- [ ] Support grid and list layouts
- [ ] Implement sorting options
- [ ] Add filtering capabilities
- [ ] Show loading skeletons
- [ ] Pull to refresh

### Detail Views

- [ ] Display full metadata
- [ ] Show poster/backdrop images
- [ ] Quick actions available
- [ ] Smooth transitions
- [ ] Proper error states

## Performance Targets

- [ ] <1s to load movie list (cached)
- [ ] <2s to load movie list (network)
- [ ] Smooth 60fps scrolling
- [ ] Image caching working
- [ ] Memory usage <100MB

## Next Milestone Preview

Milestone 3 will add download client integration (SABnzbd and NZBGet) to enable queue management and download control.
