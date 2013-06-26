//
//  NKInitQRViewController.h
//  Notikumi Checkpoint
//
//  Created by Samuel Mascarell on 21/06/13.
//  Copyright (c) 2013 Samuel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface NKInitQRViewController : UIViewController <ZBarReaderDelegate>
{
    ZBarReaderView *readerView;
    ZBarReaderViewController *readerController;
    ZBarCameraSimulator *cameraSim;
    
}

@property (nonatomic, retain) IBOutlet ZBarReaderView *readerView;

@end
