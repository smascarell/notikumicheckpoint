//
//  MyJSON.m
//  JSON
//

#import "NKJSON.h"

@implementation NKJSON

+(NSString *) JSONFromData:(NSData *) data{
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
}

+(NSString *) JSONFromObject:(NSDictionary *) object{
    
    return [NKJSON JSONFromData:[NKJSON dataFromObject:object]];
    
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
    
    return [NKJSON objectFromData:[NKJSON dataFromJSON:json]];
    
}

+(NSDictionary *) objectFromData:(NSData *) data{
    
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
}

@end
