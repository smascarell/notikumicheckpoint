//
//  AppDelegate.m
//  Notikumi Checkpoint
//
//  Created by Samuel Mascarell on 16/11/12.
//  Copyright (c) 2012 Samuel. All rights reserved.
//

#import "AppDelegate.h"
#import "NKInitQRViewController.h"

@implementation AppDelegate

@synthesize clave = _clave;
@synthesize purlev = _purlev;
@synthesize scannerViewController = _scannerViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    // ELIMINAR esto cuando se arregle el QRInit
//    _purlev = @"2013-12-31-exposicion-de-david-canos-en-valencia";
//    _clave = @"2013-12-31-exposicion-de-david-canos-en-valenciaeca75441d2236aa24c1b98187e61582febcc3fa1";
    return YES;
}

							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"Entrando en background...");
    
    UIViewController *presented = [self.window.rootViewController presentedViewController];
    NSLog(@"%@",presented);
            
    if ([presented isMemberOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)presented;
        NSLog(@"%@",tabBarController);
        UINavigationController *navSC = (UINavigationController *)[tabBarController.viewControllers objectAtIndex:0];
        NSLog(@"%@",navSC);
        _scannerViewController = [[navSC viewControllers]objectAtIndex:0];
        [_scannerViewController.readerController.readerView stop];
        NSLog(@"%@",_scannerViewController);
    }

    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    time_t unixTimeNow = (time_t) [[NSDate date] timeIntervalSince1970];
    NSLog(@"Entrando en foreground... %lu vs %i vs %i",unixTimeNow,_vida,_vida+60*60*8);
    
    if (_vida != 0 && (_vida+60*60*8) <= unixTimeNow) {
        _clave = nil;
        _vida = 0;
        NSLog(@"Clave expirada...");    
        NSLog(@"Redireccionando a QRInit...");
        
        [self.window.rootViewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self.window.rootViewController dismissModalViewControllerAnimated:YES];
  
        return;

    }else {
        [_scannerViewController viewWillAppear:NO];
        return;
    }
    
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    _clave = nil;
    _vida = 0;
}

@end