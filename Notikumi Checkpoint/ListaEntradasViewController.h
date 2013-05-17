//
//  ListaEntradasViewController.h
//  Notikumi Checkpoint
//
//  Created by Samuel Mascarell on 07/02/13.
//  Copyright (c) 2013 Samuel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListaEntradasViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITabBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableData *responseData;

- (void)descargarListado :(NSString *)ultimoKey idevf:(NSString *)idevf;

@end