# Milestone 3: Service Integration - Phase 2

**Duration**: Weeks 7-9  
**Goal**: Implement download services (SABnzbd, NZBGet)  
**Deliverable**: Download queue management functionality

## Week 7: SABnzbd Integration

### Task 7.1: SABnzbd API Client

**Estimated Time**: 8 hours

- [ ] Create SABnzbdService protocol
- [ ] Implement API key authentication
- [ ] Define API endpoints
- [ ] Create response models
- [ ] Handle SABnzbd-specific errors

### Task 7.2: SABnzbd Data Models

**Estimated Time**: 6 hours

- [ ] Define Queue item model
- [ ] Create History model
- [ ] Implement Category models
- [ ] Add Statistics models
- [ ] Create Status/Config models

### Task 7.3: SABnzbd Repository

**Estimated Time**: 6 hours

- [ ] Implement queue operations (pause, resume, delete)
- [ ] Add history fetching
- [ ] Create priority management
- [ ] Implement category operations
- [ ] Add speed limit control

### Task 7.4: SABnzbd ViewModels

**Estimated Time**: 8 hours

- [ ] Create QueueViewModel with real-time updates
- [ ] Implement HistoryViewModel
- [ ] Build StatisticsViewModel
- [ ] Add SABnzbdSettingsViewModel
- [ ] Create QueueItemViewModel

## Week 8: SABnzbd UI & NZBGet Service

### Task 8.1: SABnzbd UI Views

**Estimated Time**: 10 hours

- [ ] Build QueueListView with drag-to-reorder
- [ ] Create QueueItemView with progress
- [ ] Implement HistoryView
- [ ] Add StatisticsView with graphs
- [ ] Create SABnzbdControlView (pause/resume/speed)

### Task 8.2: NZBGet API Client

**Estimated Time**: 8 hours

- [ ] Create NZBGetService protocol
- [ ] Implement JSON-RPC client
- [ ] Define RPC methods
- [ ] Create response models
- [ ] Handle NZBGet-specific errors

### Task 8.3: NZBGet Data Models

**Estimated Time**: 6 hours

- [ ] Define Download model
- [ ] Create PostQueue model
- [ ] Implement History model
- [ ] Add Server statistics
- [ ] Create Config models

## Week 9: NZBGet UI & Unified Interface

### Task 9.1: NZBGet Repository

**Estimated Time**: 6 hours

- [ ] Implement download operations
- [ ] Add post-processing queue
- [ ] Create history management
- [ ] Implement server control
- [ ] Add config operations

### Task 9.2: NZBGet ViewModels

**Estimated Time**: 8 hours

- [ ] Create NZBGetQueueViewModel
- [ ] Implement PostQueueViewModel
- [ ] Build NZBGetHistoryViewModel
- [ ] Add NZBGetSettingsViewModel
- [ ] Create unified DownloadViewModel

### Task 9.3: NZBGet UI Views

**Estimated Time**: 8 hours

- [ ] Build NZBGetQueueView
- [ ] Create PostProcessingView
- [ ] Implement NZBGetHistoryView
- [ ] Add NZBGetControlView
- [ ] Create NZBGetSettingsView

### Task 9.4: Unified Download Interface

**Estimated Time**: 8 hours

- [ ] Create protocol for download clients
- [ ] Build unified QueueView
- [ ] Implement service switcher
- [ ] Add combined statistics
- [ ] Create download search integration

## Advanced Features

### Task A1: Real-time Updates

**Estimated Time**: 6 hours

- [ ] Implement WebSocket support for SABnzbd
- [ ] Add polling for NZBGet
- [ ] Create update coordinator
- [ ] Implement background refresh
- [ ] Add push notification support

### Task A2: Download Management

**Estimated Time**: 6 hours

- [ ] Implement batch operations
- [ ] Add download scheduling
- [ ] Create category management
- [ ] Implement priority queuing
- [ ] Add bandwidth management

## Testing & Performance

### Task T3: Download Service Tests

**Estimated Time**: 8 hours

- [ ] Test SABnzbd operations
- [ ] Test NZBGet operations
- [ ] Mock queue updates
- [ ] Test error scenarios
- [ ] Verify state management

### Task P1: Performance Optimization

**Estimated Time**: 6 hours

- [ ] Optimize queue refresh rate
- [ ] Implement intelligent polling
- [ ] Add response caching
- [ ] Optimize list rendering
- [ ] Memory usage profiling

## Acceptance Criteria

### Functional Criteria

- [ ] Can configure SABnzbd connection
- [ ] Can view and manage SABnzbd queue
- [ ] Can configure NZBGet connection
- [ ] Can view and manage NZBGet queue
- [ ] Real-time updates working
- [ ] Can pause/resume downloads
- [ ] Can reorder queue items
- [ ] History is accessible

### Technical Criteria

- [ ] Efficient API usage
- [ ] Smooth UI updates
- [ ] Proper state management
- [ ] Error recovery implemented
- [ ] > 70% test coverage

## UI/UX Requirements

### Queue Views

- [ ] Show download progress bars
- [ ] Display ETA and speed
- [ ] Support swipe actions
- [ ] Drag to reorder
- [ ] Batch selection mode

### Statistics Views

- [ ] Show speed graphs
- [ ] Display disk usage
- [ ] Show completion stats
- [ ] Historical trends
- [ ] Server performance

## Integration Points

### With Media Services

- [ ] Link downloads to movies/series
- [ ] Show download status in media views
- [ ] Enable direct download from search
- [ ] Auto-category assignment

### With System

- [ ] Background fetch enabled
- [ ] Local notifications for completion
- [ ] Widget support planned
- [ ] Shortcuts integration

## Performance Targets

- [ ] Queue updates <500ms
- [ ] Smooth progress animations
- [ ] <50MB memory for large queues
- [ ] Background refresh working
- [ ] Minimal battery impact

## Next Milestone Preview

Milestone 4 will complete service integration with Tautulli monitoring, Overseerr requests, and unified search functionality.
