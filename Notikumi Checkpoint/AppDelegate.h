//
//  AppDelegate.h
//  Notikumi Checkpoint
//
//  Created by Samuel Mascarell on 16/11/12.
//  Copyright (c) 2012 Samuel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScannerViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong) NSString * clave;
@property (strong) NSString * purlev;
@property () NSInteger vida;

@property(nonatomic, retain) ScannerViewController *scannerViewController;

@end
