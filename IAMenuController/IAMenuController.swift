/*  IAMenuController.swift
 *  IAMenuController
 *
 *  Converted to Swift by Taylor Wright-Sanson on 9/7/18.
 *  Created by Mark Adams on 12/16/11.
 *  MIT License
 */

import UIKit
import QuartzCore

@objc (IAMenuController)
open class IAMenuController: UIViewController {

  // MARK: -

  @objc open let menuViewController: UIViewController
  @objc open var contentViewController: UIViewController {
    willSet {
      let oldContent = self.contentViewController

      removeTapInterceptView()
      oldContent.willMove(toParentViewController: nil)

      UIView.animate(withDuration: 0.2,
                     animations: {
                      self.contentView.frame = self.contentViewFrameForStaging()
      }) { (finished) in
        oldContent.view.removeFromSuperview()
        oldContent.removeFromParentViewController()

        self.addChildViewController(newValue)
        self.contentView.addSubview(newValue.view)
        self.resizeViewFor(contentView: newValue.view)
        newValue.didMove(toParentViewController: self)

        UIView.animate(withDuration: 0.22,
                       delay: 0.1,
                       options: UIViewAnimationOptions.curveLinear,
                       animations: {
                        self.contentView.frame = self.contentViewFrameForClosedMenu()
        }, completion: { (finished) in
          self.menuIsVisible = false
        })
      }
    }
  }

  @objc open var contentView: UIView
  @objc open var menuIsVisible: Bool = false
  @objc open let percentageOfScreenWidthUsedByMenu: CGFloat = 86.25
  private var tapInterceptView: UIView?

  // MARK: - Initialization

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  @objc public init(menuViewController: UIViewController, contentViewController: UIViewController) {
    self.menuViewController = menuViewController
    self.contentViewController = contentViewController
    self.contentView = UIView(frame: .zero)

    super.init(nibName: nil, bundle: nil)
  }

  // MARK: - UIViewController

  override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .portrait
  }

  // MARK: - View Lifecycle

  override open func viewDidLoad() {
    super.viewDidLoad()
    setupViewControllers()
  }

  // MARK: - Child Controller Setup

  private func setupContentView() {
    contentView = UIView(frame: view.bounds)

    addPanGestureRecognizer()
    contentView.addSubview(contentViewController.view)
    resizeViewFor(contentView: contentViewController.view)
    view.addSubview(contentView)

    contentView.layer.shadowColor = UIColor.black.cgColor
    contentView.layer.shadowOffset = CGSize(width: -2.0, height: 0.0)
    contentView.layer.shadowOpacity = 0.75
    contentView.layer.shadowPath = UIBezierPath(rect: contentView.frame).cgPath
    contentView.layer.shadowRadius = 3.0
  }

  private func setupContentViewController() {
    addChildViewController(contentViewController)
    contentViewController.viewWillAppear(false)
    setupContentView()
    contentViewController.viewDidAppear(false)
    contentViewController.didMove(toParentViewController: self)
  }

  private func setupMenuViewController() {
    addChildViewController(menuViewController)
    menuViewController.view.frame = view.bounds
    view.insertSubview(menuViewController.view, belowSubview: contentView)
    menuViewController.didMove(toParentViewController: self)
  }

  private func setupTapInterceptView() {
    if tapInterceptView == nil {
      tapInterceptView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: contentView.frame.size))
      tapInterceptView!.isUserInteractionEnabled = true
      let tap = UITapGestureRecognizer(target: self, action: #selector(hideMenu))
      tapInterceptView!.addGestureRecognizer(tap)
    }
  }

  private func setupViewControllers() {
    setupContentViewController()
    setupMenuViewController()
  }

  // MARK: - Gesture Management

  private func addPanGestureRecognizer() {
    let pan: IAScreenEdgeGestureRecognizer = IAScreenEdgeGestureRecognizer(target: self, action: #selector(pan(_:)))
    contentView.addGestureRecognizer(pan)
  }

  private func addTapInterceptView() {
    if tapInterceptView == nil {
      setupTapInterceptView()
    }

    contentView.addSubview(tapInterceptView!)
  }

  private func removeTapInterceptView() {
    if tapInterceptView == nil {
      setupTapInterceptView()
    }

    tapInterceptView!.removeFromSuperview()
  }

  // MARK: - Menu State

  private func menuDidClose() {
    menuIsVisible = false
    menuViewController.viewDidDisappear(true)
    removeTapInterceptView()
    NotificationCenter.default.post(name: .IAMenuDidClose, object: nil)
  }

  private func menuDidOpen() {
    menuIsVisible = true
    menuViewController.viewDidAppear(true)
    addTapInterceptView()
    NotificationCenter.default.post(name: .IAMenuDidOpen, object: nil)
  }

  private func menuWillClose() {
    menuIsVisible = false
    menuViewController.viewWillDisappear(true)
    NotificationCenter.default.post(name: .IAMenuWillClose, object: nil)
  }

  private func menuWillOpen() {
    menuIsVisible = true
    menuViewController.viewWillAppear(true)
    NotificationCenter.default.post(name: .IAMenuWillOpen, object: nil)
  }

  // MARK: - Menu Presentation - Open

  @objc open func toggleMenu() {
    menuIsVisible ? hideMenu() : showMenu()
  }

  // MARK: - Menu Presentation - Private

  @objc private func hideMenu() {
    menuWillClose()
    UIApplication.shared.beginIgnoringInteractionEvents()

    UIView.animate(withDuration: 0.225,
                   delay: 0,
                   options: .curveEaseInOut,
                   animations: {
                    self.contentView.frame = self.contentViewFrameForClosedMenu()
    }) { (finished) in
      self.menuDidClose()
      UIApplication.shared.endIgnoringInteractionEvents()
    }
  }

  private func showMenu() {
    menuWillOpen()
    UIApplication.shared.beginIgnoringInteractionEvents()

    UIView.animate(withDuration: 0.225,
                   delay: 0,
                   options: .curveEaseInOut,
                   animations: {
                    self.contentView.frame = self.contentViewFrameForOpenMenu()
    }) { (finished) in
      self.menuDidOpen()
      UIApplication.shared.endIgnoringInteractionEvents()
    }
  }

  // MARK: - Pan Gesture Support

  @objc private func pan(_ pan: UIPanGestureRecognizer) {
    let translation = pan.translation(in: contentView)
    let velocity = pan.velocity(in: contentView)

    let minimumX: CGFloat = 0.0
    let maximumX: CGFloat = menuWidth()

    if pan.state == .began {
      return
    } else if pan.state == .changed {
      var currentFrame = contentView.frame
      let newX = currentFrame.origin.x + translation.x

      if newX < minimumX, newX > maximumX { return }

      currentFrame.origin.x = currentFrame.origin.x + translation.x
      contentView.frame = currentFrame
    } else if pan.state == .ended {
      if contentView.frame.minX == 0.0 { return }

      var finalX = contentView.frame.origin.x + (0.55 * velocity.y)
      var travelDistance: CGFloat = 0.0

      if finalX >= view.frame.midX {
        finalX = maximumX
        travelDistance = maximumX - contentView.frame.minX
        menuWillOpen()
      } else {
        finalX = minimumX
        travelDistance = minimumX + contentView.frame.minX
        menuWillClose()
      }

      var duration = travelDistance / abs(velocity.x)

      if duration < 0.1 {
        duration = 0.1
      } else if duration > 0.25 {
        duration = 0.25
      }

      UIView.animate(withDuration: TimeInterval(duration),
                     delay: 0,
                     options: .curveEaseOut,
                     animations: {
                      var frame = self.contentView.frame
                      frame.origin.x = finalX
                      self.contentView.frame = frame
      }) { (finished) in
        if finalX == maximumX {
          self.menuDidOpen()
        } else if finalX == 0.0 {
          self.menuDidClose()
        }
      }
    }

    pan.setTranslation(.zero, in: self.contentView)
  }

  // MARK: - Frame Calculation

  private func contentViewFrameForClosedMenu() -> CGRect {
    var frame = self.contentView.frame
    frame.origin.x = 0.0

    return frame
  }

  private func contentViewFrameForStaging() -> CGRect {
    var frame = self.contentView.frame
    frame.origin.x = view.frame.maxX + UIScreen.main.bounds.size.width - menuWidth()

    return frame
  }

  private func contentViewFrameForOpenMenu() -> CGRect {
    var frame = self.contentView.frame
    frame.origin.x = menuWidth()

    return frame
  }

  private func menuWidth() -> CGFloat {
    return UIScreen.main.bounds.size.width * percentageOfScreenWidthUsedByMenu / 100.0
  }

  private func resizeViewFor(contentView: UIView) {
    contentView.frame = view.bounds
  }

  // MARK: - Open Methods For Objc Availability

  @objc open class func iAMenuWillOpenNotification() -> String { return IAMenuWillOpenNotification }
  @objc open class func iAMenuDidOpenNotification() -> String { return IAMenuDidOpenNotification }
  @objc open class func iAMenuWillCloseNotification() -> String { return IAMenuWillCloseNotification }
  @objc open class func iAMenuDidCloseNotification() -> String { return IAMenuDidCloseNotification }
}

// MARK: - Notification Constants

private let IAMenuWillOpenNotification: String = "IAMenuWillOpenNotification"
private let IAMenuDidOpenNotification: String = "IAMenuDidOpenNotification"
private let IAMenuWillCloseNotification: String = "IAMenuWillCloseNotification"
private let IAMenuDidCloseNotification: String = "IAMenuDidCloseNotification"

public extension Notification.Name {
  static let IAMenuWillOpen = Notification.Name(IAMenuWillOpenNotification)
  static let IAMenuDidOpen = Notification.Name(IAMenuDidOpenNotification)
  static let IAMenuWillClose = Notification.Name(IAMenuWillCloseNotification)
  static let IAMenuDidClose = Notification.Name(IAMenuDidCloseNotification)
}

// MARK: - UIViewController Extension

extension UIViewController {
  @objc open func menuController() -> IAMenuController? {
    guard let parent = parent else { return nil }

    if parent.isKind(of: IAMenuController.self) {
      return parent as? IAMenuController
    }

    return parent.menuController()
  }
}
