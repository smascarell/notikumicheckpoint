//
//  ListaEntradasViewController.m
//  Notikumi Checkpoint
//
//  Created by Samuel Mascarell on 07/02/13.
//  Copyright (c) 2013 Samuel. All rights reserved.
//

#import "ListaEntradasViewController.h"

@interface ListaEntradasViewController ()

@end

@implementation ListaEntradasViewController


@synthesize responseData = _responseData;

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
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
        
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    NSString * msgAlerta = [NSString stringWithFormat:@"Listado no disponible en esta versión. Próximamente...."];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:msgAlerta delegate:self cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
    [alert show];
    
    //[self descargarListado:@"0847ec8e0c739dda41b932e1efaa7db9d60dc131" idevf:@"157528"];    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    //UITabBarItem *tabItem = [self.tabBarController.tabBar.items objectAtIndex:0];
    [self.tabBarController setSelectedIndex:0];

}// after animation


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        static NSString *identificadorCelda2 = @"celdaEntrada";
        UITableViewCell *celda = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identificadorCelda2];
        if (celda == nil) {
            celda = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identificadorCelda2];
        }
        return celda;
}

#pragma mark NSURLConnection

- (void)descargarListado :(NSString *)ultimoKey idevf:(NSString *)idevf {
        
    NSMutableString *notikumiURL = [[NSMutableString alloc]initWithString:@"http://api.notikumi.com/ticket/"];
    //NSArray *localizador = [ultimoKey componentsSeparatedByString:@"_"];
    
    [notikumiURL appendString:[NSString stringWithFormat:@"smth.json?"]];
    [notikumiURL appendString:[NSString stringWithFormat:@"&key=%@",ultimoKey]];
    [notikumiURL appendString:[NSString stringWithFormat:@"&idevf=%@",idevf]];
    [notikumiURL appendString:[NSString stringWithFormat:@"&type=3"]];
    time_t unixTime = (time_t) [[NSDate date] timeIntervalSince1970];
    [notikumiURL appendString:[NSString stringWithFormat:@"&time=%ld",unixTime]];
    
    NSLog(@"%@",notikumiURL);
    
    //GET http://api.notikumi.com/ticket/<localizador>.json?type=1&idevf=<ideventofecha>&key=<apikey>
    
    //    NSURL *url = [NSURL URLWithString:notikumiURL];
    //    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    //    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    //    [NSURLConnection
    //     sendAsynchronousRequest:urlRequest
    //     queue:queue
    //     completionHandler:^(NSURLResponse *response,
    //                         NSData *data,
    //                         NSError *error) {
    //         if ([data length] >0 &&
    //             error == nil){
    //             NSString *html = [[NSString alloc] initWithData:data
    //                                                    encoding:NSUTF8StringEncoding];
    //             NSLog(@"HTML = %@", html);
    //         }
    //         else if ([data length] == 0 &&
    //                  error == nil){
    //             NSLog(@"Nothing was downloaded.");
    //         }
    //         else if (error != nil){
    //             NSLog(@"Error happened = %@", error);
    //         }
    //     }];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:notikumiURL]];
    NSURLConnection *conn;
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"Respuesta del servidor OK");
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"Descarga de datos finalizada");
    NSLog(@"OK! %d bytes de datos recibidos",[self.responseData length]);
    
//    // convert to JSON
//    NSError *myError = nil;
//    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
//    
//    NSDictionary *objectDTO = [res objectForKey:@"objectDTO"];
//    BOOL errorValue = [[objectDTO objectForKey:@"error"] boolValue];
//    
//    NSLog(@"errorValue: %@", objectDTO);
//    
//    if (!errorValue) {
//        self.accesoLabel.textColor = [UIColor greenColor];
//        
//        NSURL *url = [[NSBundle mainBundle] URLForResource:@"entrada_valida" withExtension: @"mp3"];
//        if (!url){NSLog(@"file not found"); return;}
//        NSError *error;
//        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
//        [audioPlayer play];
//        
//    } else{
//        self.accesoLabel.text = @"NO válida";
//        self.accesoLabel.textColor = [UIColor redColor];
//        
//        NSURL *url = [[NSBundle mainBundle] URLForResource:@"entrada_no_valida" withExtension: @"mp3"];
//        if (!url){NSLog(@"file not found"); return;}
//        NSError *error;
//        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
//        [audioPlayer play];
//    }
//    [self limpiarAccesoLabel];
    
}

@end
