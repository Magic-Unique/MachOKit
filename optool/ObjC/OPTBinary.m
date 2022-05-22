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

@end

@implementation OPTBinary (Operation)

- (BOOL)install:(NSString *)path {
    if (![self readIfNeed]) {
        return NO;
    }
    struct thin_header headers[4];
    uint32_t archCount = 0;
    headersFromBinary(headers, self.contents, &archCount);
    for (uint32_t i = 0; i < archCount; i++) {
        struct thin_header macho = headers[i];
        uint32_t command = LC_LOAD_DYLIB;
        if (!insertLoadEntryIntoBinary(path, self.contents, macho, command)) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)uninstall:(NSString *)path {
    if (![self readIfNeed]) {
        return NO;
    }
    struct thin_header headers[4];
    uint32_t archCount = 0;
    headersFromBinary(headers, self.contents, &archCount);
    for (uint32_t i = 0; i < archCount; i++) {
        struct thin_header macho = headers[i];
        if (!removeLoadEntryFromBinary(self.contents, macho, path)) {
            return NO;
        }
    }
    return YES;
}

@end
