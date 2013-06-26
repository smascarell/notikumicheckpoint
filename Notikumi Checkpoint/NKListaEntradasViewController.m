//
//  ListaEntradasViewController.m
//  Notikumi Checkpoint
//
//  Created by Samuel Mascarell on 07/02/13.
//  Copyright (c) 2013 Samuel. All rights reserved.
//

#import "NKListaEntradasViewController.h"
#import "AppDelegate.h"
#import "NKJSON.h"
#import "NKCeldaEntradas.h"

@interface NKListaEntradasViewController ()
   
@end

@implementation NKListaEntradasViewController
@synthesize entradas = _entradas;

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
    [self descargarListadoEntradas];
    [self.tableView reloadData];

}
-(void)viewDidDisappear:(BOOL)animated {
    _entradas = nil;
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
    return _entradas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identificadorCelda2 = @"celdaEntrada";
    NKCeldaEntradas *celda = (NKCeldaEntradas *)[tableView dequeueReusableCellWithIdentifier:identificadorCelda2];
    if (celda == nil) {
        celda = (NKCeldaEntradas *)[tableView dequeueReusableCellWithIdentifier:identificadorCelda2];
    }
    
    NSDictionary *entrada   = [NSDictionary dictionaryWithDictionary:[_entradas objectAtIndex:indexPath.row]];
    
    NSMutableString *nombre        = [[NSMutableString alloc]initWithFormat:@"%@",[entrada valueForKey:@"nombre"]];
    NSString *apellidos     = [[NSString alloc]initWithFormat:@" %@",[entrada valueForKey:@"apellidos"]];
    NSString *localizador   = [[NSString alloc]initWithFormat:@"%@",[entrada valueForKey:@"localizador"]];
    //NSString *hora          = [[NSString alloc]initWithFormat:@"%@",[entrada valueForKey:@"fechaCompra"]];
    NSString *numero        = [[NSString alloc]initWithFormat:@"#%u",indexPath.row+1];
    NSInteger validada      = [[entrada valueForKey:@"asistenciaValidada"] intValue];
    NSLog(@"Validada: %i",validada);
 
    [nombre appendString:apellidos];
    celda.nombreLabel.text = nombre;
    
    celda.localizadorLabel.text = localizador;
    celda.horaLabel.text = nil;
    celda.numeroLabel.text = numero;

    if (validada == 1 ) {
        [celda.estadoBoton setImage:[UIImage imageNamed:@"checked.png"]forState:UIControlStateNormal];
    } else {
        [celda.estadoBoton setImage:[UIImage imageNamed:@"unchecked.png"]forState:UIControlStateNormal];
    }
    
    return celda;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"wverEntrada"]) {
        NSLog(@"Ver Entrada");
    }
    [self.tableView setContentOffset:CGPointMake(0,45)];
}

#pragma mark NSURLConnection

-(void) descargarListadoEntradas{
    NSLog(@"descargarListadoEntradas");
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSLog(@"Clave: %@",appDelegate.clave);
            
    NSMutableString *notikumiURL = [[NSMutableString alloc]initWithString:@"http://api.notikumi.com/ticket/smth.json"];
    
    [notikumiURL appendString:[NSString stringWithFormat:@"?purlev=%@",appDelegate.purlev]];
    [notikumiURL appendString:[NSString stringWithFormat:@"&type=3"]];
    [notikumiURL appendString:[NSString stringWithFormat:@"&checkpointInitCode=%@",appDelegate.clave]];
    
    time_t unixTime = (time_t) [[NSDate date] timeIntervalSince1970];
    [notikumiURL appendString:[NSString stringWithFormat:@"&time=%ld",unixTime]];
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:notikumiURL]];

    request.HTTPMethod = @"GET";
    NSLog(@"Conectando con servidor request:%@",request);
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    // convert to JSON
    NSDictionary *res = [NKJSON objectFromData:data];
    NSDictionary *objectDTO = [res objectForKey:@"objectDTO"];
    NSDictionary *entradasDTO = [objectDTO objectForKey:@"entradas"];

    _entradas = [NSMutableArray new];
    for (NSDictionary *entradaDTO in entradasDTO) {
        NSDictionary *entrada = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 [entradaDTO objectForKey:@"asistenteNombre"], @"nombre",
                                 [entradaDTO objectForKey:@"asistenteApellidos"], @"apellidos",
                                 [entradaDTO objectForKey:@"asistenteEmail"], @"email",
                                 [entradaDTO objectForKey:@"precio"], @"precio",
                                 [entradaDTO objectForKey:@"localizador"], @"localizador",
                                 [entradaDTO objectForKey:@"asistenciaConfirmada"], @"asistenciaConfirmada",
                                 [entradaDTO objectForKey:@"asistenciaValidada"], @"asistenciaValidada",
                                 [entradaDTO objectForKey:@"nombre"], @"tipoEntrada",
                                 [entradaDTO objectForKey:@"fechaCompra"], @"fechaCompra",
                                 [entradaDTO objectForKey:@"timestampFechaCompra"], @"fechaCompraTMS",
                                 [entradaDTO objectForKey:@"fechaAsistConfirmada"], @"fechaAsistConfirmada",
                                 [entradaDTO objectForKey:@"fechaAsistValidada"], @"fechaAsistValidada",
                                 nil];
        [_entradas addObject:entrada];
    }
    //NSLog(@"Entradas: %@",_entradas);
    self.totalLabel.text = [NSString stringWithFormat:@"Total entradas: %u",_entradas.count];
}

- (void)viewDidUnload {
    [self setTotalLabel:nil];
    [super viewDidUnload];
}
@end
