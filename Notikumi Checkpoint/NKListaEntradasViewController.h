//
//  ListaEntradasViewController.h
//  Notikumi Checkpoint
//
//  Created by Samuel Mascarell on 07/02/13.
//  Copyright (c) 2013 Samuel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NKListaEntradasViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITabBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *entradas;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;


@end