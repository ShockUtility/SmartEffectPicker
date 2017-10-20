//
//  SmartEffectPicker.h
//  SmartEffectPicker
//
//  Created by shock on 2017. 10. 20..
//

#import <UIKit/UIKit.h>

@interface SmartEffectPicker : UIViewController <UITabBarDelegate>

+ (void)startEffect:(UIViewController *)controller
              title:(NSString *)title
        sourceImage:(UIImage *)sourceImage
          completed:(void (^)(UIImage *effectedImage))completed;

@end
