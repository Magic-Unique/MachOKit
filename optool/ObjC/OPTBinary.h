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


@interface OPTBinary (Operation)

/// Inject `LC_DYLIB` to binary
/// - Parameter path: Load command path
- (BOOL)install:(NSString *)path;

/// remove `LC_DYLIB` from binary
/// - Parameter path: Load command path
- (BOOL)uninstall:(NSString *)path;

/// Rename `LC_DYLIB` load path
/// - Parameters:
///   - fromPath: From Path
///   - dstPath: New Path
- (BOOL)rename:(NSString *)fromPath into:(NSString *)dstPath;

/// Unrestrict binary
/// - Parameter soft: YES for replace content, NO for remove content
- (BOOL)disbaleRestrict:(BOOL)soft;

/// Remove code signature from binary
/// - Parameter soft: YES for replace content, NO for remove content
- (BOOL)stripCodeSignature:(BOOL)soft;

/// Disable ASLR flag from binary (remove `MH_PIE` in Mach-O flags)
- (BOOL)disableASLR;

@end
