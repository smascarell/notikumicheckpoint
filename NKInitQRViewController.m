//
//  NKInitQRViewController.m
//  Notikumi Checkpoint
//
//  Created by Samuel Mascarell on 21/06/13.
//  Copyright (c) 2013 Samuel. All rights reserved.
//

#import "NKInitQRViewController.h"
#import "NKTabBarViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import <AVFoundation/AVFoundation.h>
#import "ScannerViewController.h"

@interface NKInitQRViewController ()

@end

@implementation NKInitQRViewController

@synthesize readerView = _readerView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    readerController = [ZBarReaderViewController new];
    readerController.readerDelegate = self;
    
    readerController.showsZBarControls = NO;
    readerController.supportedOrientationsMask = UIInterfaceOrientationPortrait;
    
    [readerController.scanner setSymbology: ZBAR_I25
                                    config: ZBAR_CFG_ENABLE
                                        to: 0];
    
    readerController.readerView.zoom = 1.0f;
    readerController.readerView.maxZoom = 1.0f;
       
    UIImage *img = [UIImage imageNamed:@"QROverlay"];
    UIImageView *overlay = [[UIImageView alloc] initWithImage:img];
    
    readerController.cameraOverlayView.frame=CGRectMake(0, 0, 320, 320);

    CGAffineTransform scale = CGAffineTransformScale( CGAffineTransformMakeTranslation(0.0, 0.0), 1.0, 1.0);
    readerController.cameraViewTransform = scale;
    
    [self.view addSubview:readerController.readerView];
    [self.view addSubview:overlay];
    [self.view sendSubviewToBack:readerController.readerView];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    // ADD: get the decode results

    id <NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    
    //UIImage *image = [info objectForKey: UIImagePickerControllerOriginalImage];
    
    for(ZBarSymbol *result in results) {
        
        NSLog(@"%@",result.data);
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        // split de leido
        
        NSString *purlev = [result.data substringToIndex:result.data.length -40];
        NSString *firma = [result.data substringFromIndex:result.data.length -40];
        
        NSLog(@"Firma %@",firma);
        NSLog(@"purlev %@",purlev);
        
        // creo firma alternativa
        
        NSString *firmaAux = [self sha1:[NSString stringWithFormat:@"%@algosucioqUesEnosescurr4",purlev]];
        NSLog(@"Firma Aux: %@",firmaAux);
        
        if ([firmaAux isEqualToString:firma]) {
            NSLog(@"Firma correcta...");
//            para hacer pruebas, asginar valor a las variables de forma manual desde el AppDelegate. 
            appDelegate.clave = result.data;
            appDelegate.purlev = purlev;
            
            time_t unixTime = (time_t) [[NSDate date] timeIntervalSince1970];
            appDelegate.vida = unixTime;
            [self performSelector:@selector(redireccionar) withObject:self afterDelay:0.0];
        }
        else {
            NSLog(@"Firma incorrecta...");
            UIAlertView *alertaError = [[UIAlertView alloc]initWithTitle:@"Error" message:@"El código de inicialización no es correcto" delegate:self cancelButtonTitle:@"Cerrar" otherButtonTitles:nil, nil];
            [alertaError show];
        }
        
        break;        
    }
    
}

-(void) redireccionar {
//    UIAlertView *alertaError = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Inicialización correcta" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alertaError show];
    UITabBarController *tabbarC = [self.storyboard instantiateViewControllerWithIdentifier:@"NKTabBarPrincipal"];    
    [self presentModalViewController:tabbarC animated:YES];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [readerController.readerView start];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setReaderView:nil];
    [super viewDidUnload];
}

-(NSString*) sha1:(NSString*)input
{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    NSLog(@"%@",input);
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
    
}
@end
