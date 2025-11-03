#import <dlfcn.h>
#import <UIKit/UIKit.h>
#include <objc/message.h>

static Class verticalDividerClass;

UIColor *colorPalette[6];
//UIColor *awardColor;

@interface SliceKit : UIView
@end

@interface FlexStackView : SliceKit
@end

BOOL isColorInPalette(UIColor *color) {
    for (NSInteger i = 0; i < 6; i++) {
        if ([color isEqual:colorPalette[i]]) {
            return YES;
        }
    }
    return NO;
}

/*BOOL colorCompare(UIColor *color1, UIColor *color2) {
    CGFloat r1, g1, b1, a1;
    CGFloat r2, g2, b2, a2;

    [color1 getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
    [color2 getRed:&r2 green:&g2 blue:&b2 alpha:&a2];

    if (fabs(r1 - r2) < 0.0001 &&
        fabs(g1 - g2) < 0.0001 &&
        fabs(b1 - b2) < 0.0001 &&
        fabs(a1 - a2) < 0.0001) {
        return YES;
    } else {
        return NO;
    }
}*/

void logAndSetBackgroundColorByDepth(UIView *verticalDivider, NSInteger depth) {
    UIColor *bgColor = verticalDivider.backgroundColor;
    if (!isColorInPalette(bgColor)) {
        
        NSInteger colorIndex = depth % 6;
        UIColor *newColor = colorPalette[colorIndex];

        verticalDivider.backgroundColor = newColor;
    }
}

%hook SliceKit.FlexStackView
- (void)layoutSubviews {
    %orig();
    int verticalDividerCount = 0;
    NSArray *subviews = [self subviews];
    
    for (id subview in subviews) {
        if ([subview isKindOfClass:verticalDividerClass]) {
            verticalDividerCount++;
        }
    }
    
    if (verticalDividerCount >= 1) {
        NSInteger index = 0;
        for (id subview in subviews) {
            if ([subview isKindOfClass:verticalDividerClass]) {
                logAndSetBackgroundColorByDepth(subview, index++);
            }
        }
    }
}
%end

%ctor {
    verticalDividerClass = objc_getClass("PDP_CommentSheet_Impl.VerticalDivider");
    
    // awardColor = [UIColor colorWithRed:0.847059 green:0.631373 blue:0 alpha:1.0];
    colorPalette[0] = [UIColor redColor];
    colorPalette[1] = [UIColor colorWithHue:0.0916666667 saturation:1.0 brightness:1.0 alpha:1.0];
    colorPalette[2] = [UIColor colorWithHue:0.130555556 saturation:1.0 brightness:1.0 alpha:1.0];
    colorPalette[3] = [UIColor colorWithHue:0.333333333 saturation:1.0 brightness:1.0 alpha:1.0];
    colorPalette[4] = [UIColor blueColor];
    colorPalette[5] = [UIColor colorWithHue:0.861111111 saturation:1.0 brightness:1.0 alpha:1.0];
}
