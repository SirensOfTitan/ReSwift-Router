//
//  NavigationState.swift
//  Meet
//
//  Created by Benjamin Encz on 11/11/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import ReSwift

public enum RoutePresentationStyle {
  case normal
  case modal
}

public protocol RouteSegment {
  var presentationStyle: RoutePresentationStyle { get }
  func isEqual(to segment: RouteSegment?) -> Bool
}

extension RouteSegment {
  public var presentationStyle: RoutePresentationStyle {
    return .normal
  }
}

extension RouteSegment where Self: Equatable {
  public func isEqual(to segment: RouteSegment?) -> Bool {
    guard let segment = segment as? Self else {
      return false
    }
    return self == segment
  }
}

public struct IDRouteSegment<T: Equatable>: RouteSegment, Equatable {
  let identifier: T
  
  public init(_ identifier: T) {
      self.identifier = identifier
  }
}

public typealias Route = [RouteSegment]

public struct NavigationState {
    public init() {}

    public var route: Route = []
    var changeRouteAnimated: Bool = true
}

public protocol HasNavigationState {
    var navigationState: NavigationState { get set }
}
