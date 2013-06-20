//
//  ListaEntradasViewController.m
//  Notikumi Checkpoint
//
//  Created by Samuel Mascarell on 07/02/13.
//  Copyright (c) 2013 Samuel. All rights reserved.
//

#import "NKListaEntradasViewController.h"


@interface NKListaEntradasViewController ()

@end

@implementation NKListaEntradasViewController


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
        
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    //NSString * msgAlerta = [NSString stringWithFormat:@"Listado no disponible en esta versión. Próximamente...."];
    //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:msgAlerta delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //[alert show];
    
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
    //UIImageView *imgBG = [[UIImageView alloc]initWithImage: [UIImage imageNamed:@"list-item.png"]];
    celda.backgroundColor = [UIColor grayColor];
    //celda.backgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"list-item.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0]];
    //celda.selectedBackgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"list-item.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
    //[celda setBackgroundColor:[UIColor grayColor]];
    
    return celda;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"wverEntrada"]) {
        NSLog(@"Ver Entrada");
    }
    [self.tableView setContentOffset:CGPointMake(0,45)];
}

#pragma mark NSURLConnection

- (void)descargarListado :(NSString *)ultimoKey idevf:(NSString *)idevf {
        

}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
}

@end
