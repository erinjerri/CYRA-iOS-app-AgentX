import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = ViewController()
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        
        print("App Launched Successfully")
        return true
    }
}
