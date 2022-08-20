//
//  OPTBinary.h
//  optool
//
//  Created by 冷秋 on 2021/2/26.
//

#import <Foundation/Foundation.h>

@interface OPTBinary : NSObject

@property (nonatomic, copy, readonly) NSString *path;

@property (nonatomic, strong, readonly) NSMutableData *contents;

+ (instancetype)binaryWithPath:(NSString *)path;

- (BOOL)readIfNeed;
- (BOOL)read;

- (BOOL)save;
- (BOOL)save:(NSString *)path;

@end

typedef NS_ENUM(NSUInteger, OPTUnrestrictMethod) {
    OPTUnrestrictMethodRename,  ///< Rename restrict command
    OPTUnrestrictMethodRemove,  ///< Remove restrict command
};


@interface OPTBinary (Operation)

- (BOOL)install:(NSString *)path;

- (BOOL)uninstall:(NSString *)path;

- (BOOL)rename:(NSString *)fromPath into:(NSString *)dstPath;

- (BOOL)unrestrict:(OPTUnrestrictMethod)method;

@end
