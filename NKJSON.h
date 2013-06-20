//
//  MyJSON.h
//  JSON
//

#import <Foundation/Foundation.h>

@interface NKJSON : NSObject


+(NSString *) JSONFromData:(NSData *) data;
+(NSString *) JSONFromObject:(NSDictionary *) dictionary;

+(NSData *) dataFromJSON:(NSString *) json;
+(NSData *) dataFromObject:(NSDictionary *) dictionary;

+(NSDictionary *) objectFromJSON:(NSString *) json;
+(NSDictionary *) objectFromData:(NSData *) data;

@end