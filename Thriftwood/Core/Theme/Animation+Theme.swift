//
//  Animation+Theme.swift
//  Thriftwood
//
//  Thriftwood - Frontend for Media Management
//  Copyright (C) 2025 Matthias Wallner Géhri
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <https://www.gnu.org/licenses/>.
//

import SwiftUI

// MARK: - Animation Durations

/// Standard animation duration constants
enum AnimationDuration {
    /// Extra fast animation (0.1s) - for micro-interactions
    static let extraFast: Double = 0.1
    
    /// Fast animation (0.2s) - for quick transitions
    static let fast: Double = 0.2
    
    /// Normal animation (0.3s) - default for most UI changes
    static let normal: Double = 0.3
    
    /// Slow animation (0.4s) - for deliberate transitions
    static let slow: Double = 0.4
    
    /// Extra slow animation (0.6s) - for emphasis
    static let extraSlow: Double = 0.6
}

// MARK: - Standard Animations

extension Animation {
    
    // MARK: - Easing Animations
    
    /// Quick spring animation (for button presses, taps)
    static var quickSpring: Animation {
        .spring(response: 0.3, dampingFraction: 0.7)
    }
    
    /// Smooth spring animation (default for UI transitions)
    static var smoothSpring: Animation {
        .spring(response: 0.4, dampingFraction: 0.8)
    }
    
    /// Bouncy spring animation (for playful interactions)
    static var bouncySpring: Animation {
        .spring(response: 0.5, dampingFraction: 0.6)
    }
    
    /// Gentle spring animation (for smooth, subtle changes)
    static var gentleSpring: Animation {
        .spring(response: 0.5, dampingFraction: 0.9)
    }
    
    // MARK: - Timing Curve Animations
    
    /// Quick ease-in-out (0.2s)
    static var quickEaseInOut: Animation {
        .easeInOut(duration: AnimationDuration.fast)
    }
    
    /// Standard ease-in-out (0.3s)
    static var standardEaseInOut: Animation {
        .easeInOut(duration: AnimationDuration.normal)
    }
    
    /// Slow ease-in-out (0.4s)
    static var slowEaseInOut: Animation {
        .easeInOut(duration: AnimationDuration.slow)
    }
    
    /// Quick ease-in (0.2s)
    static var quickEaseIn: Animation {
        .easeIn(duration: AnimationDuration.fast)
    }
    
    /// Quick ease-out (0.2s)
    static var quickEaseOut: Animation {
        .easeOut(duration: AnimationDuration.fast)
    }
    
    /// Standard ease-in (0.3s)
    static var standardEaseIn: Animation {
        .easeIn(duration: AnimationDuration.normal)
    }
    
    /// Standard ease-out (0.3s)
    static var standardEaseOut: Animation {
        .easeOut(duration: AnimationDuration.normal)
    }
    
    // MARK: - Linear Animations
    
    /// Quick linear (0.2s)
    static var quickLinear: Animation {
        .linear(duration: AnimationDuration.fast)
    }
    
    /// Standard linear (0.3s)
    static var standardLinear: Animation {
        .linear(duration: AnimationDuration.normal)
    }
    
    // MARK: - Semantic Animations
    
    /// Default animation for UI state changes
    static var defaultUI: Animation {
        .smoothSpring
    }
    
    /// Animation for button press feedback
    static var buttonPress: Animation {
        .quickSpring
    }
    
    /// Animation for view appearance/dismissal
    static var viewTransition: Animation {
        .standardEaseInOut
    }
    
    /// Animation for drawer/sheet presentation
    static var sheetPresentation: Animation {
        .gentleSpring
    }
    
    /// Animation for loading indicators
    static var loading: Animation {
        .linear(duration: 1.0).repeatForever(autoreverses: false)
    }
    
    /// Animation for pull-to-refresh
    static var pullToRefresh: Animation {
        .smoothSpring
    }
    
    /// Animation for tab switching
    static var tabSwitch: Animation {
        .quickEaseInOut
    }
    
    /// Animation for expanding/collapsing sections
    static var expandCollapse: Animation {
        .standardEaseInOut
    }
}

// MARK: - Transition Styles

/// Standard transition styles for view appearance/dismissal
enum TransitionStyle {
    /// Slide from right (navigation push)
    @MainActor
    static func slideRight() -> AnyTransition { .move(edge: .trailing) }
    
    /// Slide from left (navigation pop)
    @MainActor
    static func slideLeft() -> AnyTransition { .move(edge: .leading) }
    
    /// Slide from bottom (modal presentation)
    @MainActor
    static func slideUp() -> AnyTransition { .move(edge: .bottom) }
    
    /// Slide from top
    @MainActor
    static func slideDown() -> AnyTransition { .move(edge: .top) }
    
    /// Fade in/out
    @MainActor
    static func fade() -> AnyTransition { unsafe .opacity }
    
    /// Scale and fade
    static func scaleAndFade() -> AnyTransition {
        {
            unsafe AnyTransition.scale.combined(with: .opacity)
        }()
    }
    
    /// Slide and fade from right
    static func slideAndFadeRight() -> AnyTransition {
        {
            unsafe AnyTransition.move(edge: .trailing).combined(with: .opacity)
        }()
    }
    
    /// Slide and fade from bottom
    static func slideAndFadeUp() -> AnyTransition {
        {
            unsafe AnyTransition.move(edge: .bottom).combined(with: .opacity)
        }()
    }
}

// MARK: - Animation Timing Functions

/// Custom animation timing functions
struct AnimationTiming {
    /// iOS-style spring animation parameters
    static let iosSpring = (response: 0.3, dampingFraction: 0.86)
    
    /// Emphasized spring (more bouncy)
    static let emphasizedSpring = (response: 0.4, dampingFraction: 0.7)
    
    /// Decelerated spring (smooth settling)
    static let deceleratedSpring = (response: 0.5, dampingFraction: 0.95)
    
    /// Material Design-inspired timing
    static let materialEase = (duration: 0.3, curve: UnitCurve.easeInOut)
    
    /// Standard ease timing
    static let standardEase = (duration: 0.3, curve: UnitCurve.easeInOut)
    
    /// Emphasized ease (faster start)
    static let emphasizedEase = (duration: 0.4, curve: UnitCurve.easeOut)
}

// MARK: - Haptic Feedback

/// Haptic feedback styles (to be used with UIFeedbackGenerator)
enum HapticStyle {
    case light
    case medium
    case heavy
    case soft
    case rigid
    case success
    case warning
    case error
    case selection
    
    #if os(iOS)
    /// Trigger the haptic feedback
    @MainActor
    func trigger() {
        switch self {
        case .light:
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        case .medium:
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        case .heavy:
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        case .soft:
            let generator = UIImpactFeedbackGenerator(style: .soft)
            generator.impactOccurred()
        case .rigid:
            let generator = UIImpactFeedbackGenerator(style: .rigid)
            generator.impactOccurred()
        case .success:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        case .warning:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
        case .error:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
        case .selection:
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
        }
    }
    #else
    func trigger() {
        // Haptic feedback not available on macOS
    }
    #endif
}
