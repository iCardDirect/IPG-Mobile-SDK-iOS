import Foundation
import UIKit
import iCardDirectMobileSDK

class SettingsViewController : UIViewController {
    
    // MARK: Outlets
    @IBOutlet private weak var scrollView               : UIScrollView!
    @IBOutlet private weak var scrollViewHolder         : UIView!
    @IBOutlet private weak var themeLabel               : UILabel!
    @IBOutlet private weak var themeSwitch              : UISwitch!
    @IBOutlet private weak var accentColorLabel         : UILabel!
    @IBOutlet private weak var accentOption1            : UIView!
    @IBOutlet private weak var accentOption2            : UIView!
    @IBOutlet private weak var accentOption3	        : UIView!
    @IBOutlet private weak var accentOption4            : UIView!
    @IBOutlet private weak var textColorLabel           : UILabel!
    @IBOutlet private weak var textColorOption1         : UIView!
    @IBOutlet private weak var textColorOption2         : UIView!
    @IBOutlet private weak var textColorOption3         : UIView!
    @IBOutlet private weak var textColorOption4         : UIView!
    @IBOutlet private weak var appFontLabel             : UILabel!
    @IBOutlet private weak var appFontValueLabel        : UILabel!
    @IBOutlet private weak var sdkLanguageLabel         : UILabel!
    @IBOutlet private weak var sdkLanguageValueLabel    : UILabel!
    
    // MARK: Variables
    private var backgroundOptionId                      : Int = -1
    private var textOptionId                            : Int = -1
    
    // MARK: Constants
    private let sdk                                     : ICardDirectSDK = ICardDirectSDK.shared
    
    static func instantiate() -> SettingsViewController? {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = .white
        
        let labelFont = UIFont(name: view.appFontName(fontType: .regular), size: 14.0)!
        self.themeLabel.font = labelFont
        self.accentColorLabel.font = labelFont
        self.textColorLabel.font = labelFont
        self.appFontLabel.font = labelFont
        self.appFontValueLabel.font = labelFont
        self.sdkLanguageLabel.font = labelFont
        self.sdkLanguageValueLabel.font = labelFont
        
        self.themeLabel.text = "darkMode".localized()
        self.accentColorLabel.text = "backgroundColor".localized()
        self.appFontLabel.text = "sdkFont".localized()
        self.sdkLanguageLabel.text = "sdkLanguage".localized()
        
        self.setColorPickers(backgroundOptionId: self.backgroundOptionId, textOptionId: self.textOptionId)
        
        self.themeSwitch.tintColor = UIColor(hex: "#279BD8FF")
        self.themeSwitch.onTintColor = UIColor(hex: "#279BD8FF")
        self.themeSwitch.isOn = sdk.currentThemeManager().darkMode
        self.themeSwitch.addTarget(self, action: #selector(onThemeTypeChanged), for: UIControl.Event.valueChanged)
     
        self.sdkLanguageValueLabel.text = sdk.sdkLanguage().uppercased()
        
        self.sdkLanguageValueLabel.isUserInteractionEnabled = true
        self.sdkLanguageLabel.isUserInteractionEnabled = true
        self.sdkLanguageValueLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onLangSelect)))
        self.sdkLanguageLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onLangSelect)))
        
        self.appFontLabel.isUserInteractionEnabled = true
        self.appFontValueLabel.isUserInteractionEnabled = true
        self.appFontLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onFontSelect)))
        self.appFontValueLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onFontSelect)))
    }
    
    @objc private func onThemeTypeChanged() {
        sdk.currentThemeManager().darkMode = self.themeSwitch.isOn
    }
    
    private func setColorPickers(backgroundOptionId: Int, textOptionId: Int) {
        let sampleColorsArray = sampleColors()
        let optionsBackground = [self.accentOption1, self.accentOption2, self.accentOption3, self.accentOption4]
        let optionsText = [self.textColorOption1, self.textColorOption2, self.textColorOption3, self.textColorOption4]
        for i in 0..<optionsBackground.count {
            let backgroundOption = optionsBackground[i]
            backgroundOption?.backgroundColor = sampleColorsArray[i]
            backgroundOption?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBackgroundOptionSelected(tap:))))
            
            backgroundOption?.tag = i
            if backgroundOptionId == i {
                sdk.currentThemeManager().buttonColor = sampleColorsArray[i]
                sdk.currentThemeManager().toolbarColor = sampleColorsArray[i]
                backgroundOption?.layer.borderColor = UIColor.darkGray.cgColor
                backgroundOption?.layer.borderWidth = 3.0
            }
            else {
                backgroundOption?.layer.borderColor = UIColor.gray.cgColor
                backgroundOption?.layer.borderWidth = 1.0
            }
            
            let textOption = optionsText[i]
            textOption?.backgroundColor = sampleColorsArray[i]
            
            textOption?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTextColorOptionSelected(tap:))))
            textOption?.tag = i
            if textOptionId == i {
                sdk.currentThemeManager().buttonTextColor = sampleColorsArray[i]
                sdk.currentThemeManager().formTextColor = sampleColorsArray[i]
                textOption?.layer.borderColor = UIColor.darkGray.cgColor
                textOption?.layer.borderWidth = 3.0
            }
            else {
                textOption?.layer.borderColor = UIColor.gray.cgColor
                textOption?.layer.borderWidth = 1.0
            }
        }
    }
    
    @objc private func onLangSelect() {
        let alertViewController = UIAlertController(title: "selectSDKLanguage".localized(), message: "", preferredStyle: UIAlertController.Style.actionSheet)
        let options = ["EN", "DE", "BG", "ES", "FR", "IT", "RO"]
        for i in 0..<options.count {
            alertViewController.addAction(UIAlertAction(title: options[i], style: .default) { (_) in
                self.sdk.setLanguage(lang: options[i].lowercased())
                self.sdkLanguageValueLabel.text = options[i]
            })
        }
        alertViewController.addAction(UIAlertAction(title: "cancel".localized(), style: .default) { (_) in
            alertViewController.dismiss(animated: true, completion: nil)
        })
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    @objc private func onFontSelect() {
        let options : [ICFontFamily] = [.caros, .lato, .montseratt, .opensans, .raleway, .roboto, .robotoSlab, .sfProDisplay]
        let optionsText = ["Caros", "Lato", "Montseratt", "OpenSans", "Raleway", "Roboto", "Roboto Slab", "SF Pro Display"]
        let alertViewController = UIAlertController(title: "selectFont".localized(), message: "", preferredStyle: UIAlertController.Style.actionSheet)
        
        for i in 0..<options.count {
            alertViewController.addAction(UIAlertAction(title: optionsText[i], style: .default) { (_) in
                self.sdk.currentThemeManager().fontFamily = options[i]
                self.appFontValueLabel.text = optionsText[i]
            })
        }
        alertViewController.addAction(UIAlertAction(title: "cancel".localized(), style: .default) { (_) in
            alertViewController.dismiss(animated: true, completion: nil)
        })
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    @objc private func onBackgroundOptionSelected(tap: UITapGestureRecognizer) {
        self.backgroundOptionId = tap.view?.tag ?? -1
        self.setColorPickers(backgroundOptionId: self.backgroundOptionId, textOptionId: self.textOptionId)
    }
    
    @objc private func onTextColorOptionSelected(tap: UITapGestureRecognizer) {
        self.textOptionId = tap.view?.tag ?? -1
        self.setColorPickers(backgroundOptionId: self.backgroundOptionId, textOptionId: self.textOptionId)
    }
    
    private func sampleColors() -> [UIColor] {
        return [UIColor.black, UIColor.white, UIColor.orange, UIColor(hex: "#279BD8FF")!]
    }
}
