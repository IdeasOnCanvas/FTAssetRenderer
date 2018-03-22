#import "FTImageAssetRenderer.h"

@implementation FTBaseAssetRenderer (FTPDFAssetRenderer)

+ (FTImageAssetRenderer *)rendererForImageNamed:(NSString *)imageName withExtension:(NSString *)extName
{
    NSURL *URL = nil;

    // First check if the main screen has a higher scale than 1 and if a explicit
    // image for that scale exists.
    int scale = (int)[[UIScreen mainScreen] scale];
    while (scale > 1) {
        NSString *scaledImageName = [NSString stringWithFormat:@"%@@%dx", imageName, scale];
        URL = [[NSBundle mainBundle] URLForResource:scaledImageName withExtension:extName];
        if (URL != nil) { break; }
        scale -= 1;
    }

    // Otherwise load the normal image, without a scale in its name.
    if (URL == nil) {
        URL = [[NSBundle mainBundle] URLForResource:imageName withExtension:extName];
    }

    if (URL != nil) {
        FTImageAssetRenderer *renderer = [[FTImageAssetRenderer alloc] initWithURL:URL];
        return renderer;
    }
    return nil;
}

@end


@implementation FTImageAssetRenderer

@synthesize sourceImage = _sourceImage;

#pragma mark - FTBaseAssetRenderer

- (CGSize)targetSize
{
    return self.sourceImage.size;
}

- (UIImage *)imageWithCacheIdentifier:(NSString *)identifier
{
    if (self.sourceImage == nil) {
        [NSException raise:@"FTBaseAssetRendererError"
                    format:@"Can’t render an image without a source image."];
    }
    return [super imageWithCacheIdentifier:identifier];
}

- (void)drawImageInContext:(CGContextRef)context
{
    UIImage *source = self.sourceImage;
    CGRect rect = CGRectMake(0, 0, source.size.width, source.size.height);
    CGContextDrawImage(context, rect, [source CGImage]);
}

#pragma mark - FTImageAssetRenderer

- (UIImage *)sourceImage
{
    if (_sourceImage == nil && self.URL.path != nil) {
        _sourceImage = [[UIImage alloc] initWithContentsOfFile:self.URL.path];
    }

    return _sourceImage;
}

@end
