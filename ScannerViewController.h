//
//  ScannerViewController.h
//  Notikumi Checkpoint
//
//  Created by Samuel Mascarell on 16/11/12.
//  Copyright (c) 2012 Samuel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "NKListaEntradasViewController.h"

@interface ScannerViewController : UIViewController <ZBarReaderDelegate>  {
    UIView *readerView;
    ZBarReaderViewController *readerController;
    ZBarCameraSimulator *cameraSim;
    AVAudioPlayer *audioPlayer;
}
@property (weak, nonatomic) IBOutlet UILabel *localizadorLabel;
@property (weak, nonatomic) IBOutlet UILabel *accesoLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) NSMutableData *responseData;

@property (nonatomic, retain) IBOutlet UIView *readerView;
@property (nonatomic, retain) ZBarReaderViewController *readerController;

-(BOOL) validateQR :(NSString *)data;
-(void) limpiarAccesoLabel;
-(void) clearLabel;
-(IBAction)cambiarEstadoLED:(id)sender;
-(void) setTorchOn:(BOOL)isOn;
-(void) startReader;

@end