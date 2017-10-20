//
//  SmartEffectPicker.m
//  SmartEffectPicker
//
//  Created by shock on 2017. 10. 20..
//

#import "SmartEffectPicker.h"
@import GPUImage;

@interface SmartEffectPicker ()
{
    GPUImageView *imageView;
    GPUImagePicture *sourcePicture;
    
    GPUImageBrightnessFilter *filterBrightness;
    GPUImageContrastFilter *filterContrast;
    GPUImageSaturationFilter *filterSaturation;
    GPUImageGammaFilter *filterGamma;
    GPUImageSharpenFilter *filterSharpen;
    GPUImageFilterGroup *filters;
    
    BOOL isFirstActive;
}

@property (copy) UIImage            *sourceImage;
@property (copy) void               (^completedCallback)(UIImage *effectedImage);

@property (weak, nonatomic) IBOutlet UINavigationItem *navTitle;
@property (weak, nonatomic) IBOutlet UIView *vwRoot;
@property (weak, nonatomic) IBOutlet UISlider *slFilterValue;

@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (weak, nonatomic) IBOutlet UITabBarItem *tabBrightness;
@property (weak, nonatomic) IBOutlet UITabBarItem *tabContrast;
@property (weak, nonatomic) IBOutlet UITabBarItem *tabSaturation;
@property (weak, nonatomic) IBOutlet UITabBarItem *tabSharpen;
@property (weak, nonatomic) IBOutlet UITabBarItem *tabGamma;
@property (weak, nonatomic) IBOutlet UIView *vwEffect;
@end

@implementation SmartEffectPicker

- (instancetype)initWithTitle:(NSString *)title {
    self = [super initWithNibName:@"SmartEffectPicker" bundle:[NSBundle bundleForClass:SmartEffectPicker.class]];
    if (self) {
        self.title = title;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _navTitle.title = self.title;
    _tabBrightness.title = NSLocalizedString(@"Brightness", comment: @"Brightness");
    _tabContrast.title = NSLocalizedString(@"Contrast", comment: @"Contrast");
    _tabSaturation.title = NSLocalizedString(@"Saturation", comment: @"Saturation");
    _tabSharpen.title = NSLocalizedString(@"Sharpen", comment: @"Sharpen");
    _tabGamma.title = NSLocalizedString(@"Gamma", comment: @"Gamma");
    
    _vwEffect.layer.cornerRadius = 5.0;
    _vwEffect.layer.masksToBounds = true;
    
    UIImage *tile = [UIImage imageNamed:@"tile" inBundle:[NSBundle bundleForClass:SmartEffectPicker.class] compatibleWithTraitCollection:nil];
    _vwRoot.backgroundColor = [UIColor colorWithPatternImage:tile];
    _tabBar.selectedItem = _tabBrightness;
    
    isFirstActive = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (isFirstActive) {
        isFirstActive = NO;
        
        CGRect rect = AspectFitRectInRect(CGRectMake(0, 0, _sourceImage.size.width, _sourceImage.size.height),
                                          CGRectMake(0, 0, _vwRoot.frame.size.width, _vwRoot.frame.size.height));
        
        imageView = [[GPUImageView alloc] initWithFrame:rect];
        imageView.fillMode = kGPUImageFillModePreserveAspectRatio;
        [_vwRoot addSubview:imageView];
        
        filterBrightness = [[GPUImageBrightnessFilter alloc] init];
        filterContrast = [[GPUImageContrastFilter alloc] init];
        filterSaturation = [[GPUImageSaturationFilter alloc] init];
        filterSharpen = [[GPUImageSharpenFilter alloc] init];
        filterGamma = [[GPUImageGammaFilter alloc] init];
        
        [filterBrightness addTarget:filterContrast];
        [filterContrast addTarget:filterSaturation];
        [filterSaturation addTarget:filterSharpen];
        [filterSharpen addTarget:filterGamma];
        [filterGamma addTarget:imageView];
        
        filters = [[GPUImageFilterGroup alloc] init];
        [filters addTarget:imageView];
        [filters addFilter:filterBrightness];
        [filters addFilter:filterContrast];
        [filters addFilter:filterSaturation];
        [filters addFilter:filterSharpen];
        [filters addFilter:filterGamma];
        
        [filters setInitialFilters:[NSArray arrayWithObjects:filterBrightness, nil]];
        [filters setTerminalFilter:filterGamma];
        
        sourcePicture = [[GPUImagePicture alloc] initWithImage:_sourceImage smoothlyScaleOutput:YES];
        [sourcePicture addTarget:filters];
        [sourcePicture processImage];
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    if (@available(iOS 11.0, *)) {
        if (UIApplication.sharedApplication.keyWindow.safeAreaInsets.top > 0.0) // iPhoneX 와 같이 상태바 영역이 따로 존재하는 경우 상태바 표시
            return NO;
    }
    return YES;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    if (item == _tabBrightness) {                               // 기본값 = 0.0, 범위 = -1.0 ~ 1.0
        _slFilterValue.minimumValue = -1.0;
        _slFilterValue.maximumValue = 1.0;
        _slFilterValue.value = filterBrightness.brightness;
    } else if (item == _tabContrast) {                          // 기본값 = 1.0, 범위 =  0.0 ~ 4.0
        _slFilterValue.minimumValue = 0.0;
        _slFilterValue.maximumValue = 4.0;
        _slFilterValue.value = filterContrast.contrast;
    } else if (item == _tabSaturation) {                        // 기본값 = 1.0, 범위 =  0.0 ~ 2.0
        _slFilterValue.minimumValue = 0.0;
        _slFilterValue.maximumValue = 2.0;
        _slFilterValue.value = filterSaturation.saturation;
    } else if (item == _tabSharpen) {                           // 기본값 = 0.0, 범위 = -4.0 ~ 4.0
        _slFilterValue.minimumValue = -4.0;
        _slFilterValue.maximumValue = 4.0;
        _slFilterValue.value = filterSharpen.sharpness;
    } else if (item == _tabGamma) {                             // 기본값 = 1.0, 범위 =  0.0 ~ 3.0
        _slFilterValue.minimumValue = 0.0;
        _slFilterValue.maximumValue = 3.0;
        _slFilterValue.value = filterGamma.gamma;
    }
}

- (IBAction)onClickReset:(id)sender {
    if (_tabBar.selectedItem == _tabBrightness) {
        _slFilterValue.value = 0.0;
        filterBrightness.brightness = 0.0;
    } else if (_tabBar.selectedItem == _tabContrast) {
        _slFilterValue.value = 1.0;
        filterContrast.contrast = 1.0;
    } else if (_tabBar.selectedItem == _tabSaturation) {
        _slFilterValue.value = 1.0;
        filterSaturation.saturation = 1.0;
    } else if (_tabBar.selectedItem == _tabSharpen) {
        _slFilterValue.value = 0.0;
        filterSharpen.sharpness = 0.0;
    } else if (_tabBar.selectedItem == _tabGamma) {
        _slFilterValue.value = 1.0;
        filterGamma.gamma = 1.0;
    }
    
    [sourcePicture processImage];
}

- (IBAction)onChangeFilterValue:(UISlider *)sender {
    if      (_tabBar.selectedItem == _tabBrightness) filterBrightness.brightness = sender.value;
    else if (_tabBar.selectedItem == _tabContrast)   filterContrast.contrast = sender.value;
    else if (_tabBar.selectedItem == _tabSaturation) filterSaturation.saturation = sender.value;
    else if (_tabBar.selectedItem == _tabSharpen)    filterSharpen.sharpness = sender.value;
    else if (_tabBar.selectedItem == _tabGamma)      filterGamma.gamma = sender.value;
    
    [sourcePicture processImage];
}

- (IBAction)onClickCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        self.completedCallback(nil);
    }];
}

- (IBAction)onClickDone:(id)sender {
    [filters removeAllTargets];
    
    CGSize sourceSize = _sourceImage.size;
    [filters useNextFrameForImageCapture];
    [filterBrightness forceProcessingAtSize: sourceSize];
    [filterContrast forceProcessingAtSize: sourceSize];
    [filterSaturation forceProcessingAtSize: sourceSize];
    [filterSharpen forceProcessingAtSize: sourceSize];
    [filterGamma forceProcessingAtSize: sourceSize];
    [sourcePicture processImage];
    
    UIImage *image = [filters imageFromCurrentFramebufferWithOrientation: _sourceImage.imageOrientation];
    
    [self dismissViewControllerAnimated:YES completion:^{
        self.completedCallback(image);
    }];
}

+ (SmartEffectPicker *)startEffect:(UIViewController *)controller
                             title:(NSString *)title
                       sourceImage:(UIImage *)sourceImage
                         completed:(void (^)(UIImage *effectedImage))completed
{
    SmartEffectPicker *picker = [[SmartEffectPicker alloc] initWithTitle:title];
    picker.sourceImage = sourceImage;
    picker.completedCallback = completed;
    [controller presentViewController:picker animated:YES completion:nil];
    
    return picker;
}

CGFloat ScaleToAspectFitRectInRect(CGRect rfit, CGRect rtarget) {
    // first try to match width
    CGFloat s = CGRectGetWidth(rtarget) / CGRectGetWidth(rfit);
    // if we scale the height to make the widths equal, does it still fit?
    if (CGRectGetHeight(rfit) * s <= CGRectGetHeight(rtarget)) {
        return s;
    }
    // no, match height instead
    return CGRectGetHeight(rtarget) / CGRectGetHeight(rfit);
}

CGRect AspectFitRectInRect(CGRect rfit, CGRect rtarget) {
    CGFloat s = ScaleToAspectFitRectInRect(rfit, rtarget);
    CGFloat w = CGRectGetWidth(rfit) * s;
    CGFloat h = CGRectGetHeight(rfit) * s;
    CGFloat x = CGRectGetMidX(rtarget) - w / 2;
    CGFloat y = CGRectGetMidY(rtarget) - h / 2;
    return CGRectMake(x, y, w, h);
}

@end






