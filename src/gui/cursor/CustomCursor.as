/**
 * Created by Sith on 26.03.14.
 */
package gui.cursor
{
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.geom.Point;
import flash.ui.Mouse;
import flash.ui.MouseCursorData;

public class CustomCursor extends Sprite
{
    private var _view:Sprite;
    private var _cursorData:Vector.<BitmapData> = Vector.<BitmapData>([new ImgCursor]);
    private var _customCursor:MouseCursorData = new MouseCursorData();
    private const CUSTOM_ARROW:String = "customArrow";

    /* CONSTRUCTOR */
    public function CustomCursor()
    {
        _customCursor.data = _cursorData;
        _customCursor.hotSpot = new Point();
        Mouse.registerCursor(CUSTOM_ARROW, _customCursor);
        Mouse.cursor = CUSTOM_ARROW;
    }

    /* SHOW ATTACKES CURSOR */
    public static function showAttackesCursor():void
    {

    }




}
}
