//
//  RestAccess
//
//  Created by Samuel Mascarell on 29/05/13.
//  Copyright (c) 2013 Notikumi. All rights reserved.
//

#import "NKFullRestObject.h"
#import "NKJSON.h"

@implementation NKFullRestObject

-(id)initWithServer:(NSString * ) server ObjectType:(NSString *) objectType{
    
    if (self = [self init]) {
        self.objectType = objectType;
        self.server = server;
    }
    return self;
}

-(BOOL)validateQR:(NSString *)QR {
    return TRUE;
}

-(void)getAllObjects{
    
    NSString * url = [NSString stringWithFormat:@"%@/%@",self.server, self.objectType];
    
    NSMutableURLRequest *getRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    getRequest.HTTPMethod = @"GET";
    NSURLConnection * conexion =[[NSURLConnection alloc] initWithRequest:getRequest delegate:self];
    if (conexion) {
        NSLog(@"GET %@",url);
    }else{
        NSLog(@"Algo no funciona");
    }

}

-(void)getObject:(NSString * )objId{
    
    NSString * url = [NSString stringWithFormat:@"%@/%@/%@",self.server, self.objectType,objId];
    
    NSMutableURLRequest *getRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    getRequest.HTTPMethod = @"GET";
    NSURLConnection * conexion =[[NSURLConnection alloc] initWithRequest:getRequest delegate:self];
    if (conexion) {
        NSLog(@"GET %@",url);
    }else{
        NSLog(@"Algo no funciona");
    }
}

-(void)deleteObject:(NSString * )objId{
    NSString * url = [NSString stringWithFormat:@"%@/%@/%@",self.server, self.objectType, objId];
    NSMutableURLRequest *deleteRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [deleteRequest setHTTPMethod:@"DELETE"];
    NSURLConnection * conexion =[[NSURLConnection alloc] initWithRequest:deleteRequest delegate:self];
    if (conexion) {
        NSLog(@"REMOVE %@",url);
    }else{
        NSLog(@"Algo no funciona");
    }
}

-(void)addObject:(NSDictionary *)obj{
    NSString * url = [NSString stringWithFormat:@"%@/%@",self.server, self.objectType];
    
    NSMutableString *params = [NSMutableString string];
    for (NSString *key in obj) {
        NSString *val = [obj objectForKey:key];
        if ([params length])
            [params appendString:@"&"];
        [params appendFormat:@"%@=%@",key,val];
    }
    
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    postRequest.HTTPMethod = @"POST";
    
    postRequest.HTTPBody = [NSData dataWithBytes:[params UTF8String] length:[params length]];
    NSURLConnection * conexion =[[NSURLConnection alloc] initWithRequest:postRequest delegate:self];
    
    if (conexion) {
        NSLog(@"POST %@",url);
    }else{
        NSLog(@"Algo no funciona");
    }

}

-(void)updateObject:(NSDictionary *)obj{
    NSString * url = [NSString stringWithFormat:@"%@/%@/%@",self.server, self.objectType, [obj valueForKey:@"_id"]];
    //NSString * bodydata = [NSString stringWithFormat:@"name=%@&score=%@", obj[@"name"], obj[@"score"]];
    
    NSMutableString *params = [NSMutableString string];
    for (NSString *key in obj) {
        NSString *val = [obj objectForKey:key];
        if ([params length])
            [params appendString:@"&"];
        [params appendFormat:@"%@=%@",key,val];
    }
    
    NSMutableURLRequest *putRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    putRequest.HTTPMethod = @"PUT";
    
    putRequest.HTTPBody = [NSData dataWithBytes:[params UTF8String] length:[params length]];
    NSURLConnection * conexion =[[NSURLConnection alloc] initWithRequest:putRequest delegate:self];
    
    if (conexion) {
        NSLog(@"PUT %@",url);
    }else{
        NSLog(@"Algo no funciona");
    }
}

#pragma mark - URL Connection Delegate Methods



- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"La conexión ha recibido datos");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    NSDictionary *jsonDict = [NKJSON objectFromData:data];
    
    NSLog(@"La conexión ha recibido los siguiente dados: %@", [NKJSON JSONFromData:data]);
    
    if ([connection.currentRequest.HTTPMethod isEqualToString:@"GET"]) {
        if ([[connection.currentRequest.URL absoluteString] isEqualToString:[NSString stringWithFormat:@"%@/%@",self.server,self.objectType]]) {
            //GET ALL

            NSMutableArray * resArray = [NSMutableArray new];
            [resArray addObjectsFromArray:[jsonDict allValues]];
            if([self.delegate respondsToSelector:@selector(didGetAllObjects:withList:)]){
                [self.delegate didGetAllObjects:self.objectType withList: resArray];
            }
        }else{
            //GET Object
            if([self.delegate respondsToSelector:@selector(didGetObject:withData:)]){
                [self.delegate didGetObject:self.objectType withData: jsonDict];
            }
        }
    }
    if ([connection.currentRequest.HTTPMethod isEqualToString:@"POST"]) {
        //POST
        NSLog(@"%@",jsonDict);
        if([self.delegate respondsToSelector:@selector(didAddObject:withId:)]){
            [self.delegate didAddObject:self.objectType withId:(NSString *)[jsonDict valueForKey:@"_id"]];
        }
    }
    if ([connection.currentRequest.HTTPMethod isEqualToString:@"PUT"]) {
        //PUT
        if([self.delegate respondsToSelector:@selector(didUpdateObject:)]){
            [self.delegate didUpdateObject:self.objectType];
        }
    }
    if ([connection.currentRequest.HTTPMethod isEqualToString:@"DELETE"]) {
        //DELETE
        if([self.delegate respondsToSelector:@selector(didDeleteObject:)]){
            [self.delegate didDeleteObject:self.objectType];
        }
    }
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"La conexion ha terminado de cargarse");
}


@end
