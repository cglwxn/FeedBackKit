//
//  FangFeedbackView.swift
//  FangFeedBackButton
//
//  Created by cc on 2023/6/10.
//

import UIKit

enum FangFeedbackEnventType {
    case began
    case move
    case end
    case cancel
}

class FangFeedbackView: UIView {
    
    var touchBeganCallBack: ((UIView, CGPoint) -> ())?
    var touchEndCallBack: ((UIView, CGPoint) -> ())?
    var touchMoveCallBack: ((UIView, CGPoint) -> ())?
    var touchCancelCallBack: ((UIView, CGPoint) -> ())?
    
    
    /// A boolen value indicates that If the sub view will response to events.
    /// Default is false. When false, current view will response to event as the sub view will not response to events. When true, the sub views will response to events while current view will not response to the events.
    var subViewTouchFeedback: Bool = false
    
    
    /// The duration between touching the view and the scale down completion. The default is 0.25s. The duration of restoring animation will be (duration - 003)s
    var scaleDuration = 0.25
    
    private var isFirstTouchMoved = false
    private var touchEndPoint: CGPoint?
    private var touchedView: UIView?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.count > 0 {
            if let touch = touches.first {
                if subViewTouchFeedback, touch.view == self {
                    return super.touchesBegan(touches, with: event)
                }
                
                if let window = UIApplication.shared.keyWindow {
                    let p = touch.location(in: window)
                    if let responseView = (self.subViewTouchFeedback == true ? touch.view : self) {
                        self.judgeBackView(responseView, eventType: .began)
                        self.touchBeganCallBack?(responseView, p)
                    }
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.count > 0 {
            if let touch = touches.first {
                if subViewTouchFeedback, touch.view == self {
                    return super.touchesBegan(touches, with: event)
                }
                
                if let window = UIApplication.shared.keyWindow {
                    self.touchEndPoint = touch.location(in: window)
                    self.touchedView = touch.view
                    if let responseView = (self.subViewTouchFeedback == true ? self.touchedView : self) {
                        self.judgeBackView(responseView, eventType: .end)
                    }
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.count > 0 {
            if let touch = touches.first {
                if subViewTouchFeedback, touch.view == self {
                    return super.touchesBegan(touches, with: event)
                }
                
                if let window = UIApplication.shared.keyWindow {
                    let p = touch.location(in: window)
                    if let responseView = (self.subViewTouchFeedback == true ? touch.view : self) {
                        self.judgeBackView(responseView, eventType: .move)
                        self.touchMoveCallBack?(responseView, p)
                    }
                }
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.count > 0 {
            if let touch = touches.first {
                if subViewTouchFeedback, touch.view == self {
                    return super.touchesBegan(touches, with: event)
                }
                
                if let window = UIApplication.shared.keyWindow {
                    let p = touch.location(in: window)
                    if let responseView = (self.subViewTouchFeedback == true ? touch.view : self) {
                        self.judgeBackView(responseView, eventType: .cancel)
                        self.touchCancelCallBack?(responseView, p)
                    }
                }
            }
        }
    }
    
    private func judgeBackView(_ view: UIView, eventType: FangFeedbackEnventType) {
        switch eventType {
        case .began:
            self.startBackViewAnimation(view, eventType: eventType)
        case .move:
            if isFirstTouchMoved {
                isFirstTouchMoved = false
            }
        case .end:
            self.resetBackViewAnimation(view, eventType: eventType)
        case .cancel:
            if view.layer.presentation()?.transform.m11 ?? 0 < 1 {
                self.resetBackViewAnimation(view, eventType: eventType)
            }
        }
    }
    
    private func startBackViewAnimation(_ view: UIView, eventType: FangFeedbackEnventType) {
        isFirstTouchMoved = true
        let timeFx = CAMediaTimingFunction(name: .easeOut)
        let anix = CABasicAnimation(keyPath: "transform.scale.x")
        if scaleDuration > 0.03 {
            anix.duration = self.scaleDuration
        } else {
            anix.duration = 0.25
        }
        anix.timingFunction = timeFx
        anix.fromValue = NSNumber(floatLiteral: Double(view.layer.presentation()?.transform.m11 ?? 0.0))
        anix.toValue = NSNumber(floatLiteral: 0.955)
        view.layer.add(anix, forKey: "transform.scale.x")
        
        let aniy = CABasicAnimation(keyPath: "transform.scale.y")
        if scaleDuration > 0.03 {
            anix.duration = self.scaleDuration
        } else {
            anix.duration = 0.25
        }
        let timeFy = CAMediaTimingFunction(name: .easeOut)
        aniy.timingFunction = timeFy
        aniy.fromValue = NSNumber(floatLiteral: Double(view.layer.presentation()?.transform.m11 ?? 0.0))
        aniy.toValue = NSNumber(floatLiteral: 0.955)
        view.layer.add(aniy, forKey: "transform.scale.y")
        
        view.transform = CGAffineTransformScale(.identity, 0.955, 0.955)
    }
    
    private func resetBackViewAnimation(_ view: UIView, eventType: FangFeedbackEnventType) {
        let timex = CAMediaTimingFunction(name: .easeIn)
        let timey = CAMediaTimingFunction(name: .easeIn)
        view.layer.removeAnimation(forKey: "transform.scale.x")
        view.layer.removeAnimation(forKey: "transform.scale.y")
        let anix = CABasicAnimation(keyPath: "transform.scale.x")
        if eventType == .end {
            anix.delegate = self
        }
        
        if self.scaleDuration > 0.03 {
            anix.duration = self.scaleDuration - 0.03
        } else {
            anix.duration = 0.22
        }
        anix.timingFunction = timex
        anix.fromValue = NSNumber(floatLiteral: Double(view.layer.presentation()?.transform.m11 ?? 0.0))
        anix.toValue = NSNumber(floatLiteral: 1.0)
        view.layer.add(anix, forKey: "transform.scale.x")
        
        let aniy = CABasicAnimation(keyPath: "transform.scale.y")
        if self.scaleDuration > 0.03 {
            anix.duration = self.scaleDuration - 0.03
        } else {
            anix.duration = 0.22
        }
        
        aniy.timingFunction = timey
        anix.fromValue = NSNumber(floatLiteral: Double(view.layer.presentation()?.transform.m11 ?? 0.0))
        anix.toValue = NSNumber(floatLiteral: 1.0)
        view.layer.add(aniy, forKey: "transform.scale.y")
        
        view.layer.transform = CATransform3DIdentity
    }
    
    
    private func feedbackGenerator(feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: feedbackStyle)
        generator.prepare()
        generator.impactOccurred()
    }
}

extension FangFeedbackView: CAAnimationDelegate {
    func animationDidStart(_ anim: CAAnimation) {
        
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.feedbackGenerator(feedbackStyle: .light)
            if let touchEndPoint = self.touchEndPoint, let responseView = (self.subViewTouchFeedback == true ? self.touchedView : self) {
                self.touchEndCallBack?(responseView, touchEndPoint)
            }
        }
    }
}

extension FangFeedbackView: UIGestureRecognizerDelegate {
    
}
