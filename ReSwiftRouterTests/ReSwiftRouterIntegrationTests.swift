//
//  SwiftFlowRouterTests.swift
//  SwiftFlowRouterTests
//
//  Created by Benjamin Encz on 12/2/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Nimble
import Quick
import ReSwift
@testable import ReSwiftRouter

class MockRoutable: Routable {
  var callsToPushRouteSegment: [(routeSegment: RouteSegment, animated: Bool)] = []
  var callsToPopRouteSegment: [(routeSegment: RouteSegment, animated: Bool)] = []
  var callsToChangeRouteSegment: [(
    from: RouteSegment,
    to: RouteSegment,
    animated: Bool
  )] = []

  func pushRouteSegment(
    _ routeSegment: RouteSegment,
    animated: Bool,
    completionHandler: @escaping RoutingCompletionHandler
  ) -> Routable {
    callsToPushRouteSegment.append(
      (routeSegment: routeSegment, animated: animated)
    )
    completionHandler()
    return MockRoutable()
  }

  func popRouteSegment(
    _ routeSegment: RouteSegment,
    animated: Bool,
    completionHandler: @escaping RoutingCompletionHandler) {
    callsToPopRouteSegment.append(
      (routeSegment: routeSegment, animated: animated)
    )
    completionHandler()
  }

  func changeRouteSegment(
    _ from: RouteSegment,
    to: RouteSegment,
    animated: Bool,
    completionHandler: @escaping RoutingCompletionHandler
  ) -> Routable {
    completionHandler()

    callsToChangeRouteSegment.append((from: from, to: to, animated: animated))

    return MockRoutable()
  }
}

struct FakeAppState: StateType {
  var navigationState = NavigationState()
}

func fakeReducer(action _: Action, state: FakeAppState?) -> FakeAppState {
  return state ?? FakeAppState()
}

func appReducer(action: Action, state: FakeAppState?) -> FakeAppState {
  return FakeAppState(
    navigationState: NavigationReducer.handleAction(action, state: state?.navigationState)
  )
}

class SwiftFlowRouterIntegrationTests: QuickSpec {
  override func spec() {
    describe("routing calls") {
      var store: Store<FakeAppState>!

      beforeEach {
        store = Store(reducer: appReducer, state: FakeAppState())
      }

      describe("setup") {
        it("does not request the root view controller when no route is provided") {
          class FakeRootRoutable: Routable {
            var called = false

            func pushRouteSegment(_: RouteSegment,
                                  completionHandler _: RoutingCompletionHandler) -> Routable {
              called = true
              return MockRoutable()
            }
          }

          let routable = FakeRootRoutable()
          _ = Router(store: store, rootRoutable: routable) { state in
            state.select { $0.navigationState }
          }

          expect(routable.called).to(beFalse())
        }

        it("requests the root with identifier when an initial route is provided") {
          store.dispatch(
            SetRouteAction(
              [IDRouteSegment("TabBarViewController")]
            )
          )

          class FakeRootRoutable: Routable {
            var calledWithSegment: (RouteSegment?) -> Void

            init(calledWithSegment: @escaping (RouteSegment?) -> Void) {
              self.calledWithSegment = calledWithSegment
            }

            func pushRouteSegment(_ routeSegment: RouteSegment, animated _: Bool, completionHandler: @escaping RoutingCompletionHandler) -> Routable {
              calledWithSegment(routeSegment)

              completionHandler()
              return MockRoutable()
            }
          }

          waitUntil(timeout: 2.0) { fullfill in
            let rootRoutable = FakeRootRoutable { identifier in
              if IDRouteSegment("TabBarViewController").isEqual(to: identifier) {
                fullfill()
              }
            }

            _ = Router(store: store, rootRoutable: rootRoutable) { state in
              state.select { $0.navigationState }
            }
          }
        }

        it("calls push on the root for a route with two elements") {
          store.dispatch(
            SetRouteAction(
              ["TabBarViewController", "SecondViewController"].map(IDRouteSegment.init)
            )
          )

          class FakeChildRoutable: Routable {
            var calledWithSegment: (RouteSegment?) -> Void

            init(calledWithSegment: @escaping (RouteSegment?) -> Void) {
              self.calledWithSegment = calledWithSegment
            }

            func pushRouteSegment(_ routeSegment: RouteSegment, animated _: Bool, completionHandler: @escaping RoutingCompletionHandler) -> Routable {
              calledWithSegment(routeSegment)

              completionHandler()
              return MockRoutable()
            }
          }

          waitUntil(timeout: 5.0) { completion in
            let fakeChildRoutable = FakeChildRoutable() { identifier in
              if IDRouteSegment("SecondViewController").isEqual(to: identifier) {
                completion()
              }
            }

            class FakeRootRoutable: Routable {
              let injectedRoutable: Routable

              init(injectedRoutable: Routable) {
                self.injectedRoutable = injectedRoutable
              }

              func pushRouteSegment(_: RouteSegment,
                                    animated _: Bool,
                                    completionHandler: @escaping RoutingCompletionHandler) -> Routable {
                completionHandler()
                return injectedRoutable
              }
            }

            _ = Router(store: store, rootRoutable:
              FakeRootRoutable(injectedRoutable: fakeChildRoutable)) { state in
              state.select { $0.navigationState }
            }
          }
        }
      }
    }

    describe("configuring animated/unanimated navigation") {
      var store: Store<FakeAppState>!
      var mockRoutable: MockRoutable!
      var router: Router<FakeAppState>!

      beforeEach {
        store = Store(reducer: appReducer, state: nil)
        mockRoutable = MockRoutable()
        router = Router(store: store, rootRoutable: mockRoutable) { state in
          state.select { $0.navigationState }
        }

        // silence router not read warning, need to keep router alive via reference
        _ = router
      }

      context("when dispatching an animated route change") {
        beforeEach {
          store.dispatch(SetRouteAction([IDRouteSegment("someRoute")], animated: true))
        }

        it("calls routables asking for an animated presentation") {
          expect(mockRoutable.callsToPushRouteSegment.last?.animated).toEventually(beTrue())
        }
      }

      context("when dispatching an unanimated route change") {
        beforeEach {
          store.dispatch(SetRouteAction([IDRouteSegment("someRoute")], animated: false))
        }

        it("calls routables asking for an animated presentation") {
          expect(mockRoutable.callsToPushRouteSegment.last?.animated).toEventually(beFalse())
        }
      }

      context("when dispatching a default route change") {
        beforeEach {
          store.dispatch(SetRouteAction([IDRouteSegment("someRoute")]))
        }

        it("calls routables asking for an animated presentation") {
          expect(mockRoutable.callsToPushRouteSegment.last?.animated).toEventually(beTrue())
        }
      }
    }
  }
}
