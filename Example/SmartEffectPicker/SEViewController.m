//
//  SEViewController.m
//  SmartEffectPicker
//
//  Created by ShockUtility on 10/20/2017.
//  Copyright (c) 2017 ShockUtility. All rights reserved.
//

#import "SEViewController.h"
@import SmartEffectPicker;

@interface SEViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation SEViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onClick:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *pickedImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    if (pickedImage!=nil) {
        [self dismissViewControllerAnimated:YES completion:^{
            [SmartEffectPicker startEffect:self
                                     title:NSLocalizedString(@"Effect", comment: @"Effect")
                               sourceImage:pickedImage
                                 completed:^(UIImage *effectedImage) {
                                     if (effectedImage != nil) {
                                         self.imageView.image = effectedImage;
                                     }
                                 }];
        }];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
