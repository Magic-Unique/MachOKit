# MachOKit

******

## Usage(MachOKit): Parse MachO files

> This is a CocoaPods wrap [DeVaukz/MachO-Kit](https://github.com/DeVaukz/MachO-Kit.git). Support macOS, iOS, tvOS platforms.

In `Podfile`

```ruby
pod 'libMachO', :git => 'https://github.com/Magic-Unique/MachOKit.git', :tag => '0.1.1'
pod 'MachOKit', :git => 'https://github.com/Magic-Unique/MachOKit.git', :tag => '0.1.1'
```

And then

```objective-c
#import <MachOKit/MachOKit.h>
```

******

## Usage(optool): modify LOAD_CMD

> This is a CocoaPods wrap [alexzielenski/optool](https://github.com/alexzielenski/optool). Support macOS, iOS platforms.

In `Podfile`

```ruby
pod 'optool', :git => 'https://github.com/Magic-Unique/MachOKit.git', :tag => '0.1.4'
```

And then

```objc
#import <optool/optool.h>

OPTBinary *binary = [OPTBinary binaryWithPath:@"App.app/App"];
[binary read]; // This step is optional
// ... do something operations here ...
BOOL bs = [binary save]; // Or save to new path: [binary save:@"App.app/NewApp"]


// Support operations:

// 1. Delete LC_LOAD_DYLIB
[binary uninstall:@"@executable_path/xxx.dylib"];
// 2. Add LC_LOAD_DYLIB
[binary install:@"@executable_path/xxxxx.dylib"];
// 3. Redirect LC_LOAD_DYLIB
[binary rename:@"/Library/Frameworks/CydiaSubstrate.framework/CydiaSubstrate"
          into:@"@executable_path/libsubstrate.dylib"]; 
// 4. Disable __RESTRICT
[binary unrestrict:OPTUnrestrictMethodRename]; // Or OPTUnrestrictMethodRemove

```

