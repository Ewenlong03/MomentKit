# UUActionSheet

[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://raw.githubusercontent.com/CheeryLau/UUActionSheet/master/LICENSE)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/v/UUActionSheet.svg?style=flat)](https://cocoapods.org/pods/UUActionSheet)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/p/UUActionSheet.svg?style=flat)](https://cocoapods.org/pods/UUActionSheet)&nbsp;

![UUActionSheet](UUActionSheet.gif)


自定义样式的`ActionSheet`，有点像WeChat或者新浪微博，使用方式和`UIActionsheet`相同，代理也是仿照`UIActionSheet`写的。

## 安装[CocoaPods]

1. `pod "UUActionSheet"`;
2. `pod install` / `pod update`;
3. `#import <UUActionSheet.h>`.

**示例：**

```objc
UUActionSheet *actionSheet = [[UUActionSheet alloc] initWithTitle:@"After the exit will not delete any historical data, the next login can still use this account."
                                                         delegate:self
                                                cancelButtonTitle:@"Cancel"
                                           destructiveButtonTitle:@"Logout"
                                                otherButtonTitles:@"Okay",nil];
[actionSheet showInView:self.view.window];
```

```objc
#pragma mark - UUActionSheetDelegate
- (void)actionSheet:(UUActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex:%ld",buttonIndex);
}
```

## 后记

不定时更新，如有问题欢迎给我[留言](https://github.com/CheeryLau/UUActionSheet/issues)，我会及时回复。如果这个工具对你有一些帮助，请给我一个star，谢谢。

