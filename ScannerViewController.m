//
//  ScannerViewController.m
//  Notikumi Checkpoint
//
//  Created by Samuel Mascarell on 16/11/12.
//  Copyright (c) 2012 Samuel. All rights reserved.
//

#import "ScannerViewController.h"
#import "MyJSON.h"

@interface ScannerViewController ()

@end

@implementation ScannerViewController

@synthesize responseData = _responseData;
@synthesize readerView;
@synthesize accesoLabel = _accesoLabel;
@synthesize localizadorLabel = _localizadorLabel;

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
    //[ZBarReaderView class];
    self.responseData = [NSMutableData data];
    [super viewDidLoad];
    self.accesoLabel.text = @"";
    
    // the delegate receives decode results
    
    readerController = [ZBarReaderViewController new];
    readerController.readerDelegate = self;
    
    readerController.showsZBarControls = NO;
    
    [readerController.scanner setSymbology: ZBAR_I25
                          config: ZBAR_CFG_ENABLE
                              to: 0];
    
    
    readerController.readerView.zoom = 0.0;
    
    UIImage *img = [UIImage imageNamed:@"QROverlay"];
    UIImageView *overlay = [[UIImageView alloc] initWithImage:img];
    
    readerController.cameraOverlayView = overlay;
        
    [readerView addSubview:readerController.readerView];
    [readerView addSubview:overlay];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    // Do any additional setup after loading the view.
    [readerController.readerView start];
    [self.localizadorLabel setText:@""];
    [self.accesoLabel setText:@"Leer Entrada"];
    [self.accesoLabel setTextColor:[UIColor whiteColor]];
    [self.activityIndicator setHidesWhenStopped:YES];
        
}
-(void)viewWillDisappear:(BOOL)animated {
    [readerView stop];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return NO;
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    // ADD: get the decode results
    
    [self.activityIndicator startAnimating];
    [self.accesoLabel setText:@"Leyendo Entrada"];
    id <NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    
    //UIImage *image = [info objectForKey: UIImagePickerControllerOriginalImage];

    for(ZBarSymbol *result in results) {
        
        NSArray *localizador = [result.data componentsSeparatedByString:@"_"];
        
        //validamos la entrada con el servidor
        
        [self validateQR:result.data];
        
        [self.localizadorLabel setText:[NSString stringWithFormat:@"%@", localizador[2]]];
        
        break;
    }
    
    //[picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL) validateQR :(NSString *)qrdata {    
   
    NSMutableString *notikumiURL = [[NSMutableString alloc]initWithString:@"http://api.notikumi.com/ticket/"];   
    NSArray *localizador = [qrdata componentsSeparatedByString:@"_"];
       
    [notikumiURL appendString:[NSString stringWithFormat:@"%@.json?",localizador[2]]];
    [notikumiURL appendString:[NSString stringWithFormat:@"&key=%@",localizador[1]]];
    [notikumiURL appendString:[NSString stringWithFormat:@"&idevf=%@",localizador[0]]];
    [notikumiURL appendString:[NSString stringWithFormat:@"&type=1"]];
    time_t unixTime = (time_t) [[NSDate date] timeIntervalSince1970];
    [notikumiURL appendString:[NSString stringWithFormat:@"&time=%ld",unixTime]];
    
    NSLog(@"%@",notikumiURL);
           
    //GET http://api.notikumi.com/ticket/<localizador>.json?type=1&idevf=<ideventofecha>&key=<apikey>
        
    [self.accesoLabel setText:@"Validando..."];
    
    //NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:notikumiURL]];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:notikumiURL]];
    request.HTTPMethod = @"GET";
    NSURLConnection *conn;
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    return YES;
}

#pragma mark NSURLConnection

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"Respuesta del servidor OK");
    [self.accesoLabel setText:nil];
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"Descarga de datos finalizada");
    NSLog(@"OK! %d bytes de datos recibidos",[self.responseData length]);
    
    // convert to JSON
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
        
    NSDictionary *objectDTO = [res objectForKey:@"objectDTO"];
    BOOL errorValue = [[objectDTO objectForKey:@"error"] boolValue];
    
    NSLog(@"errorValue: %@", objectDTO);
    
    if (!errorValue) {
        self.accesoLabel.text = @"Válida";
        self.accesoLabel.textColor = [UIColor greenColor];
        
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"entrada_valida" withExtension: @"mp3"];
        if (!url){NSLog(@"file not found"); return;}
        NSError *error;
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        [audioPlayer play];
        
    } else{
        self.accesoLabel.text = @"NO válida";
        self.accesoLabel.textColor = [UIColor redColor];
               
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"entrada_no_valida" withExtension: @"mp3"];
        if (!url){NSLog(@"file not found"); return;}
        NSError *error;
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        [audioPlayer play];
    }
    [self limpiarAccesoLabel];
    
}

- (void) limpiarAccesoLabel {
    [self performSelector:@selector(clearLabel) withObject:self afterDelay:3.0];
    //[UIView animateWithDuration:1.0 animations:^{RocketMove.center = CGPointMake(100, -55);}];
}



- (void)clearLabel {
    [self.accesoLabel setText:@"Leer Entrada"];
    [self.accesoLabel setTextColor:[UIColor whiteColor]];
    [self.localizadorLabel setText:nil];
    [self.activityIndicator stopAnimating];
    //[NSObject cancelPreviousPerformRequestsWithTarget:self];
}

@end
