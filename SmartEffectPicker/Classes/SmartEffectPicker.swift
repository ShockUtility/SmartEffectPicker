//
//  SmartEffectPicker.swift
//  SmartEffectPicker
//
//  Created by shock on 2017. 10. 18..
//

import UIKit
import GPUImage

open class SmartEffectPicker: UIViewController {

    @IBOutlet weak var vwRoot: UIView!
    @IBOutlet weak var slFilterValue: UISlider!
    
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var tabBrightness: UITabBarItem!
    @IBOutlet weak var tabContrast: UITabBarItem!
    @IBOutlet weak var tabSaturation: UITabBarItem!
    @IBOutlet weak var tabSharpen: UITabBarItem!
    @IBOutlet weak var tabGamma: UITabBarItem!
        
    var sourceImage: UIImage!
    var completedCallback: ((_ effectedImage: UIImage?) -> Void)!

    var imageView: GPUImageView?
    var sourcePicture: GPUImagePicture?
    
    var filterBrightness = GPUImageBrightnessFilter()
    var filterContrast   = GPUImageContrastFilter()
    var filterSaturation = GPUImageSaturationFilter()
    var filterGamma      = GPUImageGammaFilter()
    var filterSharpen    = GPUImageSharpenFilter()
    var filters          = GPUImageFilterGroup()
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(title: String) {
        let bundle = Bundle(for: SmartEffectPicker.self)
        super.init(nibName: "SmartEffectPicker", bundle: bundle)
        
        self.title = title
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.selectedItem = tabBrightness
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let rect =  AspectFitRectInRect(CGRect(x: 0, y: 0, width: sourceImage.size.width, height: sourceImage.size.height),
                                        CGRect(x: 0, y: 0, width: vwRoot.frame.width, height: vwRoot.frame.height))
        
        imageView = GPUImageView(frame: rect)
        imageView?.fillMode = kGPUImageFillModePreserveAspectRatio
        vwRoot.addSubview(imageView!)
        print(rect, self.view.frame)
        
        filterBrightness.addTarget(filterContrast)
        filterContrast.addTarget(filterSaturation)
        filterSaturation.addTarget(filterSharpen)
        filterSharpen.addTarget(filterGamma)
        filterGamma.addTarget(imageView)
                
        filters.addTarget(imageView)
        filters.addFilter(filterBrightness)
        filters.addFilter(filterContrast)
        filters.addFilter(filterSaturation)
        filters.addFilter(filterSharpen)
        filters.addFilter(filterGamma)        
        
        filters.initialFilters = NSArray(array: [filterBrightness]) as! [Any]
        filters.terminalFilter = filterSharpen
        
        sourcePicture = GPUImagePicture(image: sourceImage, smoothlyScaleOutput: true)
        sourcePicture?.addTarget(filters)
        sourcePicture?.processImage()
    }
    
    override open var prefersStatusBarHidden : Bool {
        return true
    }
    
    func AspectFitRectInRect(_ rfit: CGRect, _ rtarget: CGRect) -> CGRect {
        var s = rtarget.width / rfit.width
        
        if (rfit.height * s > rtarget.height) {
            s = rtarget.height / rfit.height
        }
        
        let w = rfit.width * s
        let h = rfit.height * s

        return CGRect(x: rtarget.midX - w / 2.0, y: rtarget.midY - h / 2.0, width: w, height: h)
    }
}

extension SmartEffectPicker: UITabBarDelegate {
    public func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item {
        case tabBrightness:
            slFilterValue.minimumValue = -1.0
            slFilterValue.maximumValue = 1.0
            slFilterValue.value = Float(filterBrightness.brightness)
            break
        case tabContrast:
            slFilterValue.minimumValue = 0.25
            slFilterValue.maximumValue = 4.0
            slFilterValue.value = Float(filterContrast.contrast)
            break
        case tabSaturation:
            slFilterValue.minimumValue = 0.0
            slFilterValue.maximumValue = 2.0
            slFilterValue.value = Float(filterSaturation.saturation)
            break
        case tabSharpen:
            slFilterValue.minimumValue = 0.0
            slFilterValue.maximumValue = 2.0
            slFilterValue.value = Float(filterSharpen.sharpness)
            break
        case tabGamma:
            slFilterValue.minimumValue = 0.25
            slFilterValue.maximumValue = 4.0
            slFilterValue.value = Float(filterGamma.gamma)
            break
        default: break
        }
    }
}

// Event

extension SmartEffectPicker {
    @IBAction func onChangeFilterValue(_ sender: UISlider) {
        if let item = tabBar.selectedItem {
            switch item {
            case tabBrightness :
                filterBrightness.brightness = CGFloat(sender.value)
                break
            case tabContrast :
                filterContrast.contrast = CGFloat(sender.value)
                break
            case tabSaturation :
                filterSaturation.saturation = CGFloat(sender.value)
                break
            case tabSharpen :
                filterSharpen.sharpness = CGFloat(sender.value)
                break
            case tabGamma :
                filterGamma.gamma = CGFloat(sender.value)
                break
            default: break
            }
            sourcePicture?.processImage()
        }
    }
    
    @IBAction func onClickReset(_ sender: Any) {
        slFilterValue.value = 0.0
        if let item = tabBar.selectedItem {
            switch item {
            case tabBrightness :
                filterBrightness.brightness = 0.0
                break
            case tabContrast :
                filterContrast.contrast = 1.0
                break
            case tabSaturation :
                filterSaturation.saturation = 1.0
                break
            case tabSharpen :
                filterSharpen.sharpness = 0.4
                break
            case tabGamma :
                filterGamma.gamma = 1.0
                break
            default: break
            }
            sourcePicture?.processImage()
        }
    }
    
    @IBAction func onClickCancel(_ sender: Any) {
        dismiss(animated: true) {
            self.completedCallback?(nil)
        }
    }
    
    @IBAction func onClickDone(_ sender: Any) {
        filters.removeAllTargets()
        
        let sourceSize = sourceImage.size
        filters.useNextFrameForImageCapture()
        filterBrightness.forceProcessing(at: sourceSize)
        filterContrast.forceProcessing(at: sourceSize)
        filterSaturation.forceProcessing(at: sourceSize)
        filterSharpen.forceProcessing(at: sourceSize)
        filterGamma.forceProcessing(at: sourceSize)
        sourcePicture?.processImage()
        
        let image = filters.imageFromCurrentFramebuffer(with: sourceImage.imageOrientation)
        
        dismiss(animated: true) {
            self.completedCallback?(image)
        }
    }
}

// Global

extension SmartEffectPicker {
    open class func startEffect(_ controller: UIViewController,
                                title: String,
                                sourceImage: UIImage,
                                completed: @escaping (_ effectedImage: UIImage?) -> Void)
    {
        let picker = SmartEffectPicker(title: title)
        picker.modalPresentationStyle = .overCurrentContext
        picker.modalTransitionStyle = .crossDissolve
        picker.sourceImage = sourceImage
        picker.completedCallback = completed
        
        controller.present(picker, animated: true) {
        }
    }
}






