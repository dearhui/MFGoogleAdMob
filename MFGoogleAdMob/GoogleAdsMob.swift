import UIKit
import GoogleMobileAds

//MARK: - Google Ads Unit ID
struct GoogleAdsUnitID {
    static var strBannerAdsID = "ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXXX"
    static var strInterstitialAdsID = "ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXXX"
}

struct GoogleAdsCustomKey {
    static var Date = "GoogleAdMob.Interstitial.Date"
    static var TimeInterval = 60.0
    static var TimeIntervalDebug = 60.0
}

//MARK: - Banner View Size
struct BannerViewSize {
    
    static var screenWidth = UIScreen.main.bounds.size.width
    static var screenHeight = UIScreen.main.bounds.size.height
    static var height = CGFloat((UIDevice.current.userInterfaceIdiom == .pad ? 90 : 50))
}

public enum BannerPinLocation : Int {
    
    case top
    case bottom
}

//MARK: - Create GoogleAdMob Class
class GoogleAdMob:NSObject, GADInterstitialDelegate, GADBannerViewDelegate {
    
    //MARK: - Shared Instance
    static let sharedInstance : GoogleAdMob = {
        let instance = GoogleAdMob()
        return instance
    }()
    
//MARK: - Variable
    private var isBannerViewDisplay = false
    
    private var isInitializeBannerView = false
    private var isInitializeInterstitial = false
    
    private var interstitialAds: GADInterstitial!
    private var bannerView: GADBannerView!

//MARK: - Create Banner View
    func setupGoogleAdmob(BannerAdsID:String, InterstitialAdsID:String, TimeInterval:TimeInterval) {
        GoogleAdsUnitID.strBannerAdsID = BannerAdsID
        GoogleAdsUnitID.strInterstitialAdsID = InterstitialAdsID
        GoogleAdsCustomKey.TimeInterval = TimeInterval
    }
    
    private func initializeBannerView(rootViewController:UIViewController) {
        self.bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        self.bannerView.adUnitID = GoogleAdsUnitID.strBannerAdsID
        self.bannerView.rootViewController = rootViewController
        self.bannerView.delegate = self
        self.bannerView.backgroundColor = .gray
        self.bannerView.load(GADRequest())
        isInitializeBannerView = true
    }
    
    func destroyBannerView() {
        self.isInitializeBannerView = false
        self.bannerView.removeFromSuperview()
        self.bannerView = nil
    }
//MARK: - Hide - Show Banner View
    func showBannerViewWithTop(mainViewController:UIViewController) {
        self.showBannerView(location: .top, mainViewController: mainViewController)
    }
    
    func showBannerViewWithBottom(mainViewController:UIViewController) {
        self.showBannerView(location: .bottom, mainViewController: mainViewController)
    }
    
    func showBannerView(location: BannerPinLocation, mainViewController:UIViewController) {
        print("showBannerView")
        if isInitializeBannerView == false {
            
            print("First initialize Banner View")
            self.initializeBannerView(rootViewController: mainViewController)
            self.setupBannerViewLayout(location: location, superViewController: mainViewController)
        } else {
            
            print("isBannerViewCreate : true")
            self.setupBannerViewLayout(location: location, superViewController: mainViewController)
        }
        isBannerViewDisplay = true
    }
    
//MARK: - GADBannerView Delegate
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        
        print("adViewDidReceiveAd")
    }
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        
        print("adViewDidDismissScreen")
    }
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        
        print("adViewWillDismissScreen")
    }
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        
        print("adViewWillPresentScreen")
    }
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        
        print("adViewWillLeaveApplication")
    }
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        
        print("adView")
    }
//MARK: - Create Interstitial Ads
    func createInterstitial() {
        if self.interstitialExpired() {
            interstitialAds = GADInterstitial(adUnitID: GoogleAdsUnitID.strInterstitialAdsID)
            interstitialAds.delegate = self
            interstitialAds.load(GADRequest())
        }
    }
    
//MARK: - Show Interstitial Ads
    private func showInterstitial() {
        if interstitialAds.isReady {
            interstitialAds.present(fromRootViewController: (UIApplication.shared.keyWindow?.rootViewController)!)
            // record time
            self.interstitialSaveDate()
        }
    }
//MARK: - Interstitial Time
    private func interstitialSaveDate() {
        let userDefault = UserDefaults.standard
        userDefault.set(Date(), forKey: GoogleAdsCustomKey.Date)
        userDefault.synchronize()
    }
    
    private func interstitialExpired() -> Bool {
        if let date = UserDefaults.standard.value(forKey: GoogleAdsCustomKey.Date) as? Date {
            var interval = TimeInterval(GoogleAdsCustomKey.TimeInterval)
            #if DEBUG
                interval = TimeInterval(GoogleAdsCustomKey.TimeIntervalDebug)
            #endif
            if date.addingTimeInterval(interval) < Date() {
                return true
            } else {
                return false
            }
        } else {
            return true
        }
    }
    
//MARK: - GADInterstitial Delegate
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        
        print("interstitialDidReceiveAd")
        self.showInterstitial()
    }
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        
        print("interstitialDidDismissScreen")
    }
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        
        print("interstitialWillDismissScreen")
    }
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        
        print("interstitialWillPresentScreen")
    }
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        
        print("interstitialWillLeaveApplication")
    }
    func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
        
        print("interstitialDidFail")
    }
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        
        print("interstitial")
    }
    
    //MARK: - BannerView Auto Layout
    func setupBannerViewLayout(location:BannerPinLocation, superViewController:UIViewController) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        
        if let supperview = superViewController.view {
            supperview.addSubview(bannerView)
            
            if #available(iOS 9.0, *) {
                
                bannerView.leadingAnchor.constraint(equalTo: supperview.leadingAnchor, constant: 0).isActive = true
                supperview.trailingAnchor.constraint(equalTo: bannerView.trailingAnchor, constant: 0).isActive = true
                bannerView.heightAnchor.constraint(equalToConstant: BannerViewSize.height).isActive = true
                
                switch location {
                case .bottom:
                    superViewController.bottomLayoutGuide.topAnchor.constraint(equalTo: bannerView.bottomAnchor, constant: 0).isActive = true
                    break
                case .top:
                    bannerView.topAnchor.constraint(equalTo: superViewController.topLayoutGuide.bottomAnchor, constant: 0).isActive = true
                    break
                }
            } else {
                NSLayoutConstraint.init(item: bannerView,
                                        attribute: .leading,
                                        relatedBy: .equal,
                                        toItem: supperview,
                                        attribute: .leading,
                                        multiplier: 1.0,
                                        constant: 0).isActive = true
                
                NSLayoutConstraint.init(item: supperview,
                                        attribute: .trailing,
                                        relatedBy: .equal,
                                        toItem: bannerView,
                                        attribute: .trailing,
                                        multiplier: 1.0,
                                        constant: 0).isActive = true
                
                NSLayoutConstraint.init(item: bannerView,
                                        attribute: .height,
                                        relatedBy: .equal,
                                        toItem: nil,
                                        attribute: .height,
                                        multiplier: 1.0,
                                        constant: BannerViewSize.height).isActive = true
                switch location {
                case .bottom:
                    NSLayoutConstraint.init(item: superViewController.bottomLayoutGuide,
                                            attribute: .top,
                                            relatedBy: .equal,
                                            toItem: bannerView,
                                            attribute: .bottom,
                                            multiplier: 1.0,
                                            constant: 0).isActive = true
                    break
                case .top:
                    NSLayoutConstraint.init(item: bannerView,
                                            attribute: .top,
                                            relatedBy: .equal,
                                            toItem: superViewController.topLayoutGuide,
                                            attribute: .bottom,
                                            multiplier: 1.0,
                                            constant: 0).isActive = true
                    break
                }
            }
            supperview.layoutIfNeeded()
        }
    }
}
