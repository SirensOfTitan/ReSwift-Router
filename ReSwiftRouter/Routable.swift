//
//  Routable.swift
//  Meet
//
//  Created by Benjamin Encz on 12/3/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

public typealias RoutingCompletionHandler = () -> Void

public protocol Routable {

    func pushRouteSegment(
        _ routeSegment: RouteSegment,
        animated: Bool,
        completionHandler: @escaping RoutingCompletionHandler) -> Routable

    func popRouteSegment(
        _ routeSegment: RouteSegment,
        animated: Bool,
        completionHandler: @escaping RoutingCompletionHandler)

    func changeRouteSegment(
        _ from: RouteSegment,
        to: RouteSegment,
        animated: Bool,
        completionHandler: @escaping RoutingCompletionHandler) -> Routable
}

// A Routable entity that can handle a scenario wherein the routing segment does not change,
// but its params do.
public protocol RoutableUpdateHandler: Routable {
  
  func updateRouteSegmentParams(
    _ newSegment: RouteSegment,
    animated: Bool,
    completionHandler: @escaping RoutingCompletionHandler)
}

extension Routable {
  
    public func pushRouteSegment(
        _ routeSegment: RouteSegment,
        animated: Bool,
        completionHandler: @escaping RoutingCompletionHandler) -> Routable {
        fatalError("This routable cannot push segments. You have not implemented it. (Asked \(type(of: self)) to push \(type(of: routeSegment))")
    }

    public func popRouteSegment(
        _ routeSegment: RouteSegment,
        animated: Bool,
        completionHandler: @escaping RoutingCompletionHandler) {
        fatalError("This routable cannot pop segments. You have not implemented it. (Asked \(type(of: self)) to pop \(type(of: routeSegment))")
    }

    public func changeRouteSegment(
        _ from: RouteSegment,
        to: RouteSegment,
        animated: Bool,
        completionHandler: @escaping RoutingCompletionHandler) -> Routable {
        fatalError("This routable cannot change segments. You have not implemented it. (Asked \(type(of: self)) to change from \(type(of: from)) to \(type(of: to))")
    }

}
