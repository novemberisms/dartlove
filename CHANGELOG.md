## 0.0.1

- Initial version with Graphics, Keyboard, and Mouse support.

## 0.0.2

- Added support for LOVE2D canvases api for drawing to an external rendertarget

## 0.0.3

- Using negative scale factors in graphics calls will now properly flip images and drawables
- `dt` is now clamped to a max value to prevent massive frame jumps when latency is high.
- Added `graphics.getDimensions`, which returns a `Point` dart:math object.