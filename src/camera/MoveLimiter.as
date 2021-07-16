/**
 * Created by Sith on 05.08.14.
 */
package camera {
import camera.MovableModel;

import flash.display.Sprite;

public class MoveLimiter
{
    private var _objView:Sprite;
    private var _objModel:MovableModel;
    private var _x:Number;
    private var _y:Number;
    private var _width:Number;
    private var _height:Number;
    /*CONSTRUCTOR*/
    public function MoveLimiter(objView:Sprite, objModel:MovableModel, x:Number, y:Number, width:Number, height:Number)
    {
        _objView = objView;
        _objModel = objModel;
        _x = x;
        _y = y;
        _width = width;
        _height = height;
    }

    /* LIMITER MOVER */
    public function limitMove():void
    {
        _objModel.hitLeft = (_objView.x <= _x);
        _objModel.hitRight = (_objView.x >= _x+_width);
        _objModel.hitUp = (_objView.y <= _y);
        _objModel.hitDown = (_objView.y >= _y+_height);
    }
}
}
