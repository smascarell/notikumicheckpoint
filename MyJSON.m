//
//  MyJSON.m
//  JSON
//

#import "MyJSON.h"

@implementation MyJSON

+(NSString *) JSONFromData:(NSData *) data{
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
}

+(NSString *) JSONFromObject:(NSDictionary *) object{
    
    return [MyJSON JSONFromData:[MyJSON dataFromObject:object]];
    
}

+(NSData *) dataFromJSON:(NSString *) json{
    
    return [json dataUsingEncoding:NSUTF8StringEncoding];
    
}

+(NSData *) dataFromObject:(NSDictionary *) object{
    
    return [NSJSONSerialization dataWithJSONObject:object
                                           options:NSJSONWritingPrettyPrinted
                                             error:nil];
    
}

+(NSDictionary *) objectFromJSON:(NSString *) json{
    
    return [MyJSON objectFromData:[MyJSON dataFromJSON:json]];
    
}

+(NSDictionary *) objectFromData:(NSData *) data{
    
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
}

@end
