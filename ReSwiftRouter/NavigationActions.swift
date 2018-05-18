//
//  NavigationAction.swift
//  Meet
//
//  Created by Benjamin Encz on 11/27/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import ReSwift

public struct SetRouteAction: Action {
  let route: Route
  let animated: Bool

  public init(_ route: Route, animated: Bool = true) {
    self.route = route
    self.animated = animated
  }
}

public struct ReplaceRouteAction: Action {
  let segment: RouteSegment
  let animated: Bool

  public init(_ segment: RouteSegment, animated: Bool = true) {
    self.segment = segment
    self.animated = animated
  }
}

public struct PushRouteAction: Action {
  let segment: RouteSegment
  let animated: Bool

  public init(_ segment: RouteSegment, animated: Bool = true) {
    self.segment = segment
    self.animated = animated
  }
}

public struct PopRouteAction: Action {
  let animated: Bool

  public init(animated: Bool = true) {
    self.animated = animated
  }
}
