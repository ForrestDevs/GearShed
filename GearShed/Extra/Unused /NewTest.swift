//
//  NewTest.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-15.
//

//import SwiftUI
//import Introspect
//
//@main
//struct DemoApp: App {
//    let tabBarControllerDelegate = TabBarControllerDelegate()
//    var body: some Scene {
//        WindowGroup {
//            TabView {
//                NavigationView {
//                    List {
//                        Text("Menu list item 1")
//                        Text("Menu list item 2")
//                        Text("Menu list item 3")
//                        Text("Menu list item 4")
//                        Text("Menu list item 5")
//                    }.navigationBarTitle("Menu")
//                }
//                .tabItem {
//                    Label("Menu", systemImage: "list.dash")
//                }
//
//                NavigationView {
//                  List{
//                    Text("Order list item 1")
//                    Text("Order list item 2")
//                    Text("Order list item 3")
//                    Text("Order list item 4")
//                    Text("Order list item 5")
//                  }.navigationBarTitle("Order")
//                }
//                 .tabItem {
//                            Label("Order", systemImage: "square.and.pencil")
//                        }
//            }.introspectTabBarController { (tabBarController) in
//                tabBarController.delegate = tabBarControllerDelegate
//            }
//        }
//    }
//}
//
//
//class TabBarTransitionHandler: NSObject, UIViewControllerAnimatedTransitioning {
//
//    let viewControllers: [UIViewController]?
//    let transitionDuration: Double = 0.35
//
//    init(viewControllers: [UIViewController]?) {
//        self.viewControllers = viewControllers
//    }
//
//    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
//        return TimeInterval(transitionDuration)
//    }
//
//    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//
//        guard
//            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
//            let fromView = fromVC.view,
//            let fromIndex = self.viewControllers?.firstIndex(of: fromVC),
//            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
//            let toView = toVC.view,
//            let toIndex = self.viewControllers?.firstIndex(of: toVC)
//            else {
//                transitionContext.completeTransition(false)
//                return
//        }
//
//        let frame = transitionContext.initialFrame(for: fromVC)
//        var fromFrameEnd = frame
//        var toFrameStart = frame
//        let quarterFrame = frame.width * 0.25 //only animating from 25% of screen width.. can increase to 100% to get complete //slide
//        fromFrameEnd.origin.x = toIndex > fromIndex ? frame.origin.x - quarterFrame : frame.origin.x + quarterFrame
//        toFrameStart.origin.x = toIndex > fromIndex ? frame.origin.x + quarterFrame : frame.origin.x - quarterFrame
//        toView.frame = toFrameStart
//
//        let toCoverView = fromView.snapshotView(afterScreenUpdates: false)
//        if let toCoverView = toCoverView {
//            toView.addSubview(toCoverView)
//        }
//        let fromCoverView = toView.snapshotView(afterScreenUpdates: false)
//        if let fromCoverView = fromCoverView {
//            fromView.addSubview(fromCoverView)
//        }
//
//        DispatchQueue.main.async {
//            transitionContext.containerView.addSubview(toView)
//            UIView.animate(withDuration: self.transitionDuration, delay: 0, usingSpringWithDamping: 0.9, //initialSpringVelocity: 0.8, options: [.curveEaseOut], animations: {
//                fromView.frame = fromFrameEnd
//                toView.frame = frame
//                toCoverView?.alpha = 0
//                fromCoverView?.alpha = 1
//            }) { (success) in
//                fromCoverView?.removeFromSuperview()
//                toCoverView?.removeFromSuperview()
//                fromView.removeFromSuperview()
//                transitionContext.completeTransition(success)
//            }
//        }
//    }
//
//}
//
