import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let daysListViewController = DaysListViewController(nibName: "DaysListViewController", bundle: nil)
        presentModuleView(viewController: daysListViewController)
        return true
    }
    
    private func presentModuleView(viewController: UIViewController) {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationItem.backBarButtonItem?.title = " "
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
