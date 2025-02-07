//
//  MainTabBarController.swift
//  AirbnbApp
//
//  Created by 김상혁 on 2022/05/24.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = .Custom.gray6
        tabBar.tintColor = .Custom.gray1
        tabBar.unselectedItemTintColor = .Custom.gray3
        tabBar.layer.borderWidth = 0.25
        setUpTabBar()
    }
    
    private func setUpTabBar() {
        let searchHomeViewController = UINavigationController(rootViewController: SearchHomeViewController())
        searchHomeViewController.tabBarItem.title = "검색"
        searchHomeViewController.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        
        let wishListViewController = UIViewController()
        wishListViewController.tabBarItem.title = "위시리스트"
        wishListViewController.tabBarItem.image = UIImage(systemName: "heart")
        
        let reservationViewController = UIViewController()
        reservationViewController.tabBarItem.title = "내 예약"
        reservationViewController.tabBarItem.image = UIImage(systemName: "person")
        
        viewControllers = [
            searchHomeViewController, wishListViewController, reservationViewController
        ]
    }
}
