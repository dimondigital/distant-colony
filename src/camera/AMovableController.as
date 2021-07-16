/**
 * Created by Sith on 05.07.14.
 */
package camera
{
import flash.display.Sprite;

public class AMovableController
{
    private var _view:Sprite;
    private var _objectModel:MovableModel;


    public function AMovableController(view:Sprite, objectModel:MovableModel)
    {
        _view = view;
        _objectModel = objectModel;
    }

    /* MOVING */
    public function moving():void
    {
        if(_objectModel.isLeft && !_objectModel.hitLeft)
        {
            _objectModel.accelerationX = -0.2;
            _objectModel.speedX += _objectModel.accelerationX;
            _objectModel.vx = _objectModel.speedX;
        }
        else if(_objectModel.isRight && !_objectModel.hitRight)
        {
            _objectModel.accelerationX = 0.2;
            _objectModel.speedX += _objectModel.accelerationX;
            _objectModel.vx = _objectModel.speedX;
        }

        // limit vx speed by maxSpeed
        if(_objectModel.vx > 0 && _objectModel.vx >  _objectModel.maxSpeed)
        {
            _objectModel.vx = _objectModel.maxSpeed;
        }
        else if(_objectModel.vx < 0 &&  _objectModel.vx <  -(_objectModel.maxSpeed))
        {
            _objectModel.vx = -(_objectModel.maxSpeed);
        }


        if(_objectModel.isUp && !_objectModel.hitUp)
        {
            _objectModel.accelerationY = -0.2;
            _objectModel.speedY += _objectModel.accelerationY;
            _objectModel.vy = _objectModel.speedY;
        }
        else if(_objectModel.isDown && !_objectModel.hitDown)
        {
            _objectModel.accelerationY = 0.2;
            _objectModel.speedY += _objectModel.accelerationY;
            _objectModel.vy = _objectModel.speedY;
        }

        // limit vy speed by maxSpeed
        if(_objectModel.vy > 0 && _objectModel.vy >  _objectModel.maxSpeed)
        {
            _objectModel.vy = _objectModel.maxSpeed;
        }
        else if(_objectModel.vy < 0 &&  _objectModel.vy <  -(_objectModel.maxSpeed))
        {
            _objectModel.vy = -(_objectModel.maxSpeed);
        }

        _view.x += _objectModel.vx;
        _view.y += _objectModel.vy;
    }

    public function get view():Sprite {return _view;}
}
}
