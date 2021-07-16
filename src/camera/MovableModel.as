/**
 * Created by Sith on 11.06.14.
 */
package camera
{
import flash.display.MovieClip;
import flash.display.Sprite;

public class MovableModel extends Sprite
{
    public static const GRAVITY:Number = 0.2;

    private var _isLeft:Boolean;
    private var _isRight:Boolean;
    private var _isUp:Boolean;
    private var _isDown:Boolean;
    private var _isOnGround:Boolean;
    private var _jumpAmount:int = 0;
    private var _jumpForce:Number;
    public static const JUMP_FORCE:Number = -2.4;

    private var _speedX:Number = 0;
    private var _speedY:Number = 0;
    private var _maxSpeed:Number = 3;
    private var _accelerationX:Number = 0.2;
    private var _accelerationY:Number = 2;
    private var _vx:Number = 0;
    private var _vy:Number = 0;
    private var _isJump:Boolean;
    private var _gravity:Number;

    private var _hitLeft:Boolean;
    private var _hitRight:Boolean;
    private var _hitUp:Boolean;
    private var _hitDown:Boolean;
    private var _isAlreadyDispatchedFall:Boolean;

    private var _view:MovieClip;

    public function MovableModel()
    {

    }

    public function initView(view:MovieClip):void
    {
        _view = view;
    }

    public function get isLeft():Boolean {return _isLeft;}
    public function set isLeft(value:Boolean):void
    {
        _isLeft = value;
        if(!_isLeft)
        {
            _vx = 0;
            _accelerationX = 0;
            _speedX = 0;
        }
    }

    public function get isRight():Boolean {return _isRight;}
    public function set isRight(value:Boolean):void
    {
        _isRight = value;
        if(!_isRight)
        {
            _vx = 0;
            _accelerationX = 0;
            _speedX = 0;
        }
    }

    public function get isUp():Boolean {return _isUp;}
    public function set isUp(value:Boolean):void
    {
        _isUp = value;
        if(!_isUp)
        {
            _vy = 0;
            _accelerationY = 0;
            _speedY = 0;
        }
    }

    public function get isDown():Boolean {return _isDown;}
    public function set isDown(value:Boolean):void
    {
        _isDown = value;
        if(!_isDown)
        {
            _vy = 0;
            _accelerationY = 0;
            _speedY = 0;
        }
    }

    public function get speedX():Number {return _speedX;}
    public function set speedX(value:Number):void{_speedX = value;}

    public function get speedY():Number {return _speedY;}
    public function set speedY(value:Number):void{_speedY = value;}

    public function get accelerationX():Number {return _accelerationX;}
    public function set accelerationX(value:Number):void {_accelerationX = value;}

    public function get maxSpeed():Number {return _maxSpeed;}

    public function set vx(value:Number):void {_vx = value;}
    public function get vx():Number {return _vx;}

    public function set vy(value:Number):void {_vy = value;}
    public function get vy():Number {return _vy;}

    public function get accelerationY():Number {return _accelerationY;}
    public function set accelerationY(value:Number):void {_accelerationY = value;}

    public function get isOnGround():Boolean {return _isOnGround;}
    public function set isOnGround(value:Boolean):void
    {
        _isOnGround = value;
        /*if(_isOnGround)
        {
            if(!_isAlreadyDispatchedFall)
            {
                _isAlreadyDispatchedFall = true;
                _view.dispatchEvent(new CustomEvent(CustomEvent.FALL));
            }
        }
        else
        {
            _isAlreadyDispatchedFall = false;
        }*/
    }

    public function get jumpAmount():int {return _jumpAmount;}

    public function set jumpAmount(value:int):void {_jumpAmount = value;}

    public function get isJump():Boolean {
        return _isJump;
    }

    public function set isJump(value:Boolean):void {
        _isJump = value;
    }

    public function get hitLeft():Boolean {
        return _hitLeft;
    }

    public function set hitLeft(value:Boolean):void
    {
        _hitLeft = value;
        if(_hitLeft)
        {
            _vx = 0;
            _accelerationX = 0;
            _speedX = 0;
        }
    }

    public function get hitRight():Boolean {
        return _hitRight;
    }

    public function set hitRight(value:Boolean):void
    {
        _hitRight = value;
        if(_hitRight)
        {
            _vx = 0;
            _accelerationX = 0;
            _speedX = 0;
        }
    }

    public function get hitUp():Boolean {
        return _hitUp;
    }

    public function set hitUp(value:Boolean):void
    {
        _hitUp = value;
        if(_hitUp)
        {
            _vy = 0;
            _accelerationY = 0;
            _speedY = 0;
        }
    }

    public function get hitDown():Boolean
    {
        return _hitDown;

    }

    public function set hitDown(value:Boolean):void
    {
        _hitDown = value;
        if(_hitDown)
        {
            _vy = 0;
            _accelerationY = 0;
            _speedY = 0;
        }
    }

    public function get jumpForce():Number {
        return _jumpForce;
    }

    public function get gravity():Number {
        return _gravity;
    }

    public function set gravity(value:Number):void {
        _gravity = value;
    }

    public function set jumpForce(value:Number):void {
        _jumpForce = value;
    }
}
}
