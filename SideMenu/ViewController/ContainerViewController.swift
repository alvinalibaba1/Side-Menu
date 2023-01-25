//
//  ViewController.swift
//  SideMenu
//
//  Created by temp on 24/01/23.
//

import UIKit

class ContainerViewController: UIViewController {
    
    enum MenuState {
        case opened
        case closed
    }
    
    private var menuState: MenuState = .closed

    let menuVc = MenuViewController()
    let homeVc = HomeViewController()
    var navVC: UINavigationController?
    lazy var infoVC = InfoViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        addChildVCs()
    }

    private func addChildVCs() {
        //Menu
        menuVc.delegate = self
        addChild(menuVc)
        view.addSubview(menuVc.view)
        menuVc.didMove(toParent: self)
        
        
        //Home
        homeVc.delegate = self
        let navVC = UINavigationController(rootViewController: homeVc)
        addChild(navVC)
        view.addSubview(navVC.view)
        navVC.didMove(toParent: self)
        self.navVC = navVC
    }

}



extension ContainerViewController: HomeViewControllerDelegate {
    func didTapMenuButton() {
        toggleMenu(completion: nil)
    }
    
    
    func toggleMenu(completion: (() -> Void)?) {
        switch menuState {
        case .closed:
            //Open it
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
                
                self.navVC?.view.frame.origin.x = self.homeVc.view.frame.size.width - 100
            } completion: { [weak self] done in
                if done {
                    self?.menuState = .opened
                }
            }
        case .opened:
            //Close it
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
                
                self.navVC?.view.frame.origin.x = 0
            } completion: { [weak self] done in
                if done {
                    self?.menuState = .closed
                    DispatchQueue.main.async {
                        completion?()
                    }
                }
            }
        }
    }
}


extension ContainerViewController: menuViewControlDelegate {
    
    func didSelect(menuItem: MenuViewController.MenuOptions) {
        print("Did select")
        toggleMenu(completion: nil)
        switch menuItem {
        case .home:
            self.resetToHome()
        case .info:
            //ADD INFO CHILD
            self.addInfo()
        case .appRating:
            break
        case .shareApp:
            break
        case .settngs:
            break
        }
    }
    
    func addInfo() {
        let vc = infoVC
        
        homeVc.addChild(vc)
        homeVc.view.addSubview(vc.view)
        vc.view.frame = view.frame
        vc.didMove(toParent: homeVc)
        homeVc.title = vc.title
    }
    
    
    func resetToHome() {
        infoVC.view.removeFromSuperview()
        infoVC.didMove(toParent: nil)
        homeVc.title = "Home"
    }
}
