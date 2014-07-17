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
#import "UIColor+AppColors.h"
#import "ONAppDelegate.h"
#import "ONCongratulationsViewController.h"

@interface ONBackgroundViewController ()
- (void) launchCameraController;
- (void) dismissCameraAndLaunchMessageController;
- (void) launchMessageController;
- (void) processMessageComposeResult: (MessageComposeResult) result;
- (void) loadMessageControllerinBackground;
- (void) transitionToCongratulationsViewController;
@end

@implementation ONBackgroundViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.activityIndicator startAnimating];
    self.freshStart = YES;
    self.view.backgroundColor = [UIColor blackColor];
}

- (void) viewDidAppear:(BOOL)animated {
    ONModel *model = [ONModel sharedInstance];
    
    // If we are returning after a failed message, show the message window again
    if (model.image && self.freshStart) {
        [self performSelector: @selector(launchMessageController) withObject: nil afterDelay: 0.1];
    }
    
    // Otherwise take a picture
    else if (self.freshStart) {
        [self performSelector: @selector(launchCameraController) withObject: nil afterDelay: 0.1];
    }
    
    self.freshStart = NO;
}


#pragma mark - View Controllers

- (void) loadMessageControllerinBackground {
    [ONAppDelegate cachedMessageViewController];
}

- (void) launchCameraController {
    self.pickerController = [ONAppDelegate sharedImagePickerController];
    self.pickerController.delegate = self;
    
    [self.navigationController presentViewController: self.pickerController animated: YES completion: ^{}];
    
    [self performSelectorInBackground: @selector(loadMessageControllerinBackground) withObject: self];
}

- (void) dismissCameraAndLaunchMessageController {
    [self.pickerController dismissViewControllerAnimated: YES completion: ^ {
        [self launchMessageController];
    }];
}

- (void) launchMessageController {
    ONModel *model = [ONModel sharedInstance];
    UIImage *image = model.image;
    NSData* imageData = UIImageJPEGRepresentation(image, 0.25);

    self.messageController = [ONAppDelegate cachedMessageViewController];
    
    self.messageController.recipients = model.recipients;
    self.messageController.messageComposeDelegate = self;
    [self.messageController addAttachmentData: imageData typeIdentifier: (NSString*) kUTTypeImage filename: @"image.jpg"];
    
    self.messageController.body = [NSString stringWithFormat: @"%@ Day %ld", model.phrase, (long) model.count];
    
    [self.navigationController presentViewController: self.messageController animated: YES completion: nil];
}


#pragma mark - Picker Controller Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    ONModel *model = [ONModel sharedInstance];
    NSString* mediaType = [info valueForKey: UIImagePickerControllerMediaType];
    
    // Remember the camera that was used
    model.cameraDevice = picker.cameraDevice;
    
    if ([mediaType isEqualToString: (NSString*) kUTTypeImage]) {
        [model pictureWasJustTaken];
        [ONModel sharedInstance].image = [info valueForKey: UIImagePickerControllerOriginalImage];
        [self performSelectorOnMainThread: @selector(dismissCameraAndLaunchMessageController) withObject: nil waitUntilDone: NO];
    }
    
    else if ([mediaType isEqualToString: (NSString*) kUTTypeMovie]) {
        NSLog(@"unsupported media type");
    }
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.pickerController dismissViewControllerAnimated: YES completion:^{
        UIStoryboard *mainStoryboard;
        ONCongratulationsViewController *congratsController;
        
        mainStoryboard = [UIStoryboard storyboardWithName: @"Main_iPhone" bundle:nil];
        congratsController = [mainStoryboard instantiateViewControllerWithIdentifier: @"ONCongratulationsViewController"];
        congratsController.celebrationIsCanceled = YES;
        
        [self.navigationController pushViewController: congratsController animated: YES];
        self.freshStart = YES;
    }];
}

#pragma mark - Message Compose Delegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [ONAppDelegate clearCachedMessageViewController];
    [ONModel sharedInstance].image = nil;

    [self.messageController dismissViewControllerAnimated: YES completion: ^ {
        [self processMessageComposeResult: result];
    }];
}

- (void) processMessageComposeResult: (MessageComposeResult) result {
    
    [ONAppDelegate clearCachedMessageViewController];
    
    UIStoryboard *mainStoryboard;
    UIViewController *messageFailedController;
    
    if (result == MessageComposeResultSent) {
        self.freshStart = YES;
        [self performSelectorOnMainThread: @selector(transitionToCongratulationsViewController) withObject: nil waitUntilDone: NO];
    }
    
    else if (result == MessageComposeResultCancelled) {
        [ONModel sharedInstance].image = nil;
        [self launchCameraController];
    }
    
    else if (result == MessageComposeResultFailed) {

        // push the congratulations view controller
        mainStoryboard = [UIStoryboard storyboardWithName: @"Main_iPhone" bundle:nil];
        messageFailedController = [mainStoryboard instantiateViewControllerWithIdentifier: @"ONMessageFailedViewController"];
        [self.navigationController pushViewController: messageFailedController animated: YES];
    }
    
}

#pragma mark - Helper

- (void) transitionToCongratulationsViewController {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName: @"Main_iPhone" bundle:nil];
    UIViewController *congratsController = [mainStoryboard instantiateViewControllerWithIdentifier: @"ONCongratulationsViewController"];
    [self.navigationController pushViewController: congratsController animated: YES];
}

@end

















