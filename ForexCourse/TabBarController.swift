import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        generateTabBar()
        setTabBarAppearance()
    }

    private func generateTabBar() {
        viewControllers = [
            generateVC(
                viewController: UINavigationController(rootViewController: CoursesController()),
                image: UIImage(named: "courses"), title: "Courses".localize()
            ),
            generateVC(
                viewController:
                    UINavigationController(rootViewController: NewsViewController()),
                image: UIImage(named: "news"), title: "News".localize()
            ),
            generateVC(
                viewController: SettingsController(),
                image: UIImage(named: "settings"), title: "Settings".localize()
            )
        ]
    }

    private func generateVC(viewController: UIViewController, image: UIImage?, title: String?) -> UIViewController {
        viewController.tabBarItem.image = image
        viewController.tabBarItem.title = title
        return viewController
    }

    private func setTabBarAppearance() {
        tabBar.backgroundColor = .white
        tabBar.tintColor = UIColor(red: 0.04, green: 0.52, blue: 1, alpha: 1)
        tabBar.unselectedItemTintColor = UIColor(red: 0.56, green: 0.56, blue: 0.58, alpha: 1)
    }
}
