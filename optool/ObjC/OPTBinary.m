//
//  OPTBinary.m
//  optool
//
//  Created by 冷秋 on 2021/2/26.
//

#import "OPTBinary.h"
#import "headers.h"
#import "operations.h"

@implementation OPTBinary

+ (instancetype)binaryWithPath:(NSString *)path {
    OPTBinary *binary = [[self alloc] init];
    binary->_path = [path copy];
    return binary;
}

- (BOOL)readIfNeed {
    if (!self.contents) {
        return [self read];
    }
    return YES;
}

- (BOOL)read {
    NSMutableData *data = [NSMutableData dataWithContentsOfFile:self.path];
    if (data) {
        _contents = data;
        return YES;
    }
    return NO;
}

- (BOOL)save {
    return [self save:self.path];
}

- (BOOL)save:(NSString *)path {
    if (!self.contents) {
        return NO;
    }
    return [self.contents writeToFile:path atomically:YES];
}

- (BOOL)enumerateHeadersUsingBlock:(BOOL (^)(struct thin_header macho))block {
    struct thin_header headers[4];
    uint32_t archCount = 0;
    headersFromBinary(headers, self.contents, &archCount);
    for (uint32_t i = 0; i < archCount; i++) {
        struct thin_header macho = headers[i];
        if (!block(macho)) {
            return NO;
        }
    }
    return YES;
}

@end

@implementation OPTBinary (Operation)

- (BOOL)install:(NSString *)path {
    if (![self readIfNeed]) return NO;
    return [self enumerateHeadersUsingBlock:^BOOL(struct thin_header macho) {
        uint32_t command = LC_LOAD_DYLIB;
        return insertLoadEntryIntoBinary(path, self.contents, macho, command);
    }];
}

- (BOOL)uninstall:(NSString *)path {
    if (![self readIfNeed]) return NO;
    return [self enumerateHeadersUsingBlock:^BOOL(struct thin_header macho) {
        return removeLoadEntryFromBinary(self.contents, macho, path);
    }];
}

- (BOOL)rename:(NSString *)fromPath into:(NSString *)dstPath {
    if (![self readIfNeed]) return NO;
    return [self enumerateHeadersUsingBlock:^BOOL(struct thin_header macho) {
        return renameBinary(self.contents, macho, fromPath, dstPath);
    }];
}

- (BOOL)disbaleRestrict:(BOOL)soft {
    if (![self readIfNeed]) return NO;
    return [self enumerateHeadersUsingBlock:^BOOL(struct thin_header macho) {
        return unrestrictBinary(self.contents, macho, soft);
    }];
}

- (BOOL)stripCodeSignature:(BOOL)soft {
    if (![self readIfNeed]) return NO;
    return [self enumerateHeadersUsingBlock:^BOOL(struct thin_header macho) {
        return stripCodeSignatureFromBinary(self.contents, macho, soft);
    }];
}

- (BOOL)disableASLR {
    if (![self readIfNeed]) return NO;
    return [self enumerateHeadersUsingBlock:^BOOL(struct thin_header macho) {
        return removeASLRFromBinary(self.contents, macho);
    }];
}

@end
