//
//  RestAccess
//
//  Created by Samuel Mascarell on 29/05/13.
//  Copyright (c) 2013 Notikumi. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NKFullRestObjectDelegate <NSObject>


//Recibimos los datos solicitados mediante los siguientes protocolos
@optional
-(void)didGetAllObjects:(NSString *) objectType withList:(NSMutableArray *) list ;
-(void)didGetObject:(NSString *) objectType withData:(NSDictionary *) data;
-(void)didAddObject:(NSString *) objectType withId:(NSString *) objId ;
-(void)didDeleteObject:(NSString *) objectType;
-(void)didUpdateObject:(NSString *) objectType;

@end


@interface NKFullRestObject : NSObject <NSURLConnectionDelegate>

@property (strong) id <NKFullRestObjectDelegate> delegate;
@property (strong) NSString * server;
@property (strong) NSString * objectType;

-(id)initWithServer:(NSString * ) server ObjectType:(NSString *) objectType;

//Enviamos al servidor las peticiones mediante los siguientes métodos.
//Recibimos la información del servidor en los delegados asociados a cada uno de los métodos.
//El metodo delegado asociado a cada método lo identificamos mediante el nombre: did + <Nombre del método>
-(void)getAllObjects;

-(void)getObject:(NSString * )objId;

-(void)deleteObject:(NSString * )objId;

-(void)addObject:(NSDictionary *)obj;

-(void)updateObject:(NSDictionary *)obj;

-(BOOL)validateQR:(NSString *)QR;


@end
