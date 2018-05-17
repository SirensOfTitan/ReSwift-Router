//
//  NavigationAction.swift
//  Meet
//
//  Created by Benjamin Encz on 11/27/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import ReSwift

public struct SetRouteAction: StandardActionConvertible {

    let route: Route
    let animated: Bool
    public static let type = "RE_SWIFT_ROUTER_SET_ROUTE"

    public init (_ route: Route, animated: Bool = true) {
        self.route = route
        self.animated = animated
    }

    public init(_ action: StandardAction) {
        self.route = action.payload!["route"] as! Route
        self.animated = action.payload!["animated"] as! Bool
    }

    public func toStandardAction() -> StandardAction {
        return StandardAction(
            type: SetRouteAction.type,
            payload: ["route": route as AnyObject, "animated": animated as AnyObject],
            isTypedAction: true
        )
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

