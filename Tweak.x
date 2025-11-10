#import <dlfcn.h>
#import <UIKit/UIKit.h>
#include <objc/message.h>

@interface SliceKit : UIView
@end

@interface FlexStackView : SliceKit
@end

static Class verticalDividerClass;
UIColor *colorPalette[6];

void clearRootAwardColor(UIView *verticalDivider) {
    verticalDivider.backgroundColor = [UIColor clearColor];
}

void logAndSetBackgroundColorByDepth(UIView *verticalDivider, NSInteger depth) {
    UIColor *bgColor = verticalDivider.backgroundColor;
    NSInteger colorIndex = depth % 6;
    UIColor *newColor = colorPalette[colorIndex];

    if (![bgColor isEqual:newColor]) {
        verticalDivider.backgroundColor = newColor;
    }
}

%hook SliceKit.FlexStackView
- (void)layoutSubviews {
    %orig();
    NSArray *subviews = [self subviews];
    CGRect frame = [self frame];
    
    for (NSInteger index = 0; index < subviews.count; index++) {
        id subview = subviews[index];
        if ([subview isKindOfClass:verticalDividerClass]) {
            if (frame.origin.x == 0) {
                clearRootAwardColor(subview);
            } else {
                logAndSetBackgroundColorByDepth(subview, index);
            }
        } else {
            break;
        }
    }
}
%end

%ctor {
    verticalDividerClass = objc_getClass("PDP_CommentSheet_Impl.VerticalDivider");
    
    colorPalette[0] = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.3];
    colorPalette[1] = [UIColor colorWithHue:0.0916666667 saturation:1.0 brightness:1.0 alpha:0.3];
    colorPalette[2] = [UIColor colorWithHue:0.130555556 saturation:1.0 brightness:1.0 alpha:0.3];
    colorPalette[3] = [UIColor colorWithHue:0.333333333 saturation:1.0 brightness:1.0 alpha:0.3];
    colorPalette[4] = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.3];
    colorPalette[5] = [UIColor colorWithHue:0.861111111 saturation:1.0 brightness:1.0 alpha:0.3];
}
