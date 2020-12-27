//
//  TransitionDelegate.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 02.12.2020.
//

import UIKit

protocol ZoomingViewControllerDelegate {
    func zoomingImageView(for transition: TransitionDelegate) -> UIImageView?
    func zoomingBacgroundView(for transition: TransitionDelegate) -> UIView?
    
}

enum TransitionState {
    case initial
    case final
}

class TransitionDelegate: NSObject {

    var backgroundImageView: UIImageView?
    
    var foregroundImageView: UIImageView?
    
    var transitionDuration = 0.5
    
    var operation: UINavigationController.Operation = .none
    
    private let zoomScale = CGFloat(15)
    
    private let bacgroundScale = CGFloat(0.7)
    
    typealias ZoomingViews = (otherView: UIView, imageView: UIImageView)
    
    func configureViews(for state: TransitionState, containerView: UIView, backgroundController: UIViewController, viewsInBackground: ZoomingViews, viewsInForeground: ZoomingViews, snapshotViews: ZoomingViews) {
        switch state {
        case .initial:
            backgroundController.view.transform = CGAffineTransform.identity
            backgroundController.view.alpha = 1
            
            snapshotViews.imageView.frame = containerView.convert(viewsInBackground.imageView.frame, from: viewsInBackground.imageView.superview)
        case .final:
            backgroundController.view.transform = CGAffineTransform.identity
            backgroundController.view.alpha = 0
            
            snapshotViews.imageView.frame = containerView.convert(viewsInBackground.imageView.frame, from: viewsInForeground.imageView.superview)
        }
    }
}

extension TransitionDelegate: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        if fromVC is ZoomingViewControllerDelegate && toVC is ZoomingViewControllerDelegate {
//            self.operation = operation
            return self
//        } else {
//            return nil
//        }
    }
}

extension TransitionDelegate: UIViewControllerAnimatedTransitioning {
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let duration = transitionDuration(using: transitionContext)
        let fromVC = transitionContext.viewController(forKey: .from)!
        let toVC = transitionContext.viewController(forKey: .to)!
        let containerView = transitionContext.containerView
        
        var backgroundVC = fromVC
        var foregroundVC = toVC
        
        if operation == .pop {
            backgroundVC = toVC
            foregroundVC = fromVC
        }
        
        let imageViewSnapshot = UIImageView(image: backgroundImageView!.image)
        imageViewSnapshot.contentMode = .scaleAspectFit
        imageViewSnapshot.layer.masksToBounds = true
        
        backgroundImageView?.isHidden = true
        foregroundImageView?.isHidden = true
        let foregroundViewBackgroundColor = foregroundVC.view.backgroundColor
        foregroundVC.view.backgroundColor = .clear
        containerView.backgroundColor = .black
        
        containerView.addSubview(backgroundVC.view)
        containerView.addSubview(foregroundVC.view)
        containerView.addSubview(imageViewSnapshot)
        
        var preTransitionState = TransitionState.initial
        var postTransitionState = TransitionState.final
        
        if operation == .pop {
            preTransitionState = .final
            postTransitionState = .initial
        }
        
        configureViews(for: preTransitionState, containerView: containerView,
                       backgroundController: backgroundVC,
                       viewsInBackground: (backgroundImageView!, backgroundImageView!),
                       viewsInForeground: (foregroundImageView!, foregroundImageView!),
                       snapshotViews: (imageViewSnapshot, imageViewSnapshot))
        
        foregroundVC.view.layoutIfNeeded()
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: []) {
            self.configureViews(for: postTransitionState, containerView: containerView,
                           backgroundController: backgroundVC,
                           viewsInBackground: (self.backgroundImageView!, self.backgroundImageView!),
                           viewsInForeground: (self.foregroundImageView!, self.foregroundImageView!),
                           snapshotViews: (imageViewSnapshot, imageViewSnapshot))
        } completion: { (completed) in
            backgroundVC.view.transform = CGAffineTransform.identity
            imageViewSnapshot.removeFromSuperview()
            self.backgroundImageView?.isHidden = false
            self.foregroundImageView?.isHidden = false
            foregroundVC.view.backgroundColor = foregroundViewBackgroundColor
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }

    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }
}
