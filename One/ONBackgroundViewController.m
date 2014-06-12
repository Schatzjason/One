//
//  ONBackgroundViewController.m
//  One
//
//  Created by Jason Schatz on 6/11/14.
//  Copyright (c) 2014 Jason Schatz. All rights reserved.
//

#import "ONBackgroundViewController.h"
#import "ONModel.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface ONBackgroundViewController ()
- (BOOL) startCameraController;
@end

@implementation ONBackgroundViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.activityIndicator startAnimating];
    self.firstTime = YES;
}

- (void) viewDidAppear:(BOOL)animated {
    if (self.firstTime) {
        [self performSelector: @selector(startCameraController) withObject: nil afterDelay:0.1];
    }
    
    self.firstTime = NO;
}

- (BOOL) startCameraController {
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera] == NO) {
        NSLog(@"no camera");
        return NO;
    }
    
    self.pickerController = [[UIImagePickerController alloc] init];
    self.pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    self.pickerController.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypeCamera];
    
    self.pickerController.allowsEditing = NO;
    self.pickerController.delegate = self;
    
    [self.navigationController presentViewController: self.pickerController animated: YES completion: nil];
    
    return YES;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    NSString* mediaType = [info valueForKey: UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString: (NSString*) kUTTypeImage]) {
        [ONModel sharedInstance].image = [info valueForKey: UIImagePickerControllerOriginalImage];
        [self performSelectorOnMainThread: @selector(launchMessageController) withObject: nil waitUntilDone: NO];
    }
    
    else if ([mediaType isEqualToString: (NSString*) kUTTypeMovie]) {
        NSLog(@"unsupported media type");
    }
}

- (void) launchMessageController {

    [self.pickerController dismissViewControllerAnimated: YES completion: ^ {
        ONModel *model = [ONModel sharedInstance];
        UIImage *image = model.image;
        NSData* imageData = UIImageJPEGRepresentation(image, 0.25);
        
        self.messageController = [[MFMessageComposeViewController alloc] init];
        self.messageController.recipients = model.recipients;
        BOOL didWork = [self.messageController addAttachmentData: imageData typeIdentifier: (NSString*) kUTTypeImage filename: @"image.jpg"];
        
        NSLog(@"attachent worked: %@", didWork ? @"Yes" : @"No");
        
        [self.navigationController presentViewController: self.messageController animated: YES completion: nil];
    }];
}

@end
