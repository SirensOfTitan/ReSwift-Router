//
//  NavigationReducer.swift
//  Meet
//
//  Created by Benjamin Encz on 11/11/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import ReSwift

/**
 The Navigation Reducer handles the state slice concerned with storing the current navigation
 information. Note, that this reducer is **not** a *top-level* reducer, you need to use it within
 another reducer and pass in the relevant state slice. Take a look at the specs to see an
 example set up.
 */
public struct NavigationReducer {
  public static func handleAction(_ action: Action, state: NavigationState?) -> NavigationState {
    let state = state ?? NavigationState()

    switch action {
    case let action as SetRouteAction:
      return setRoute(state, setRouteAction: action)
    case let action as PushRouteAction:
      return pushRoute(state, pushRouteAction: action)
    case let action as PopRouteAction:
      return popRoute(state, popRouteAction: action)
    case let action as ReplaceRouteAction:
      return replaceRoute(state, replaceRouteAction: action)
    case let action as PopModalAction:
      return popModalRoute(state, popModalAction: action)
    default:
      break
    }

    return state
  }

  static func setRoute(_ state: NavigationState, setRouteAction: SetRouteAction) -> NavigationState {
    var state = state

    state.route = setRouteAction.route
    state.changeRouteAnimated = setRouteAction.animated

    return state
  }

  static func pushRoute(_ state: NavigationState, pushRouteAction: PushRouteAction) -> NavigationState {
    var state = state

    state.route.append(pushRouteAction.segment)
    state.changeRouteAnimated = pushRouteAction.animated

    return state
  }

  static func popRoute(_ state: NavigationState, popRouteAction: PopRouteAction) -> NavigationState {
    var state = state

    _ = state.route.popLast()
    state.changeRouteAnimated = popRouteAction.animated

    return state
  }

  static func replaceRoute(_ state: NavigationState, replaceRouteAction: ReplaceRouteAction) -> NavigationState {
    guard !state.route.isEmpty else {
      return state
    }

    var state = state

    _ = state.route.popLast()
    state.route.append(replaceRouteAction.segment)
    state.changeRouteAnimated = replaceRouteAction.animated

    return state
  }

  static func popModalRoute(_ state: NavigationState, popModalAction: PopModalAction) -> NavigationState {
    guard !state.route.isEmpty else {
      return state
    }

    var state = state

    while let lastRoute = state.route.last {
      _ = state.route.popLast()
      if lastRoute.presentationStyle == .modal {
        break
      }
    }

    state.changeRouteAnimated = popModalAction.animated
    return state
  }
}
