//
//  NKCeldaEntradas.h
//  Notikumi Checkpoint
//
//  Created by Samuel Mascarell on 21/06/13.
//  Copyright (c) 2013 Samuel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NKCeldaEntradas : UITableViewCell

- (IBAction)validarBoton:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *localizadorLabel;
@property (weak, nonatomic) IBOutlet UILabel *nombreLabel;
@property (weak, nonatomic) IBOutlet UILabel *horaLabel;
@property (weak, nonatomic) IBOutlet UIButton *estadoBoton;
@property (weak, nonatomic) IBOutlet UILabel *numeroLabel;


@end
