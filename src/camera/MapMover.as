package camera
{
	/*
	* ElionSea
	*
	*
	* Класс реализующий передвижение камеры за позицией игрока. Скорость перемещения
	* зависит от расстояния между двумя точками: точкой привязки и точкой координат игрока
	* Параметры _centralStagePoint и _player должны быть изначально одинаковы
	*/

import com.greensock.TweenMax;

import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageScaleMode;
	import flash.events.Event;
import flash.events.TimerEvent;
import flash.geom.Point;
	import flash.geom.Rectangle;
import flash.ui.GameInput;
import flash.utils.Timer;

public class MapMover extends Sprite
	{
		// объект к которому привязывается камера
		private var _target:DisplayObject;
		private var _stage:Stage;
		// скорости передвижения камеры по х, у
		private var _speedX:Number = 0;
		private var _speedY:Number = 0;
		// центральная точка сцены
		private var _fixPoint:Point;
		// глобальные координаты объекта
		private var _globalPlayerPoint:Point;
		// коэффицинт скорости
		private var _speedFactor:Number;

        private var _movingSprite:Sprite;
        private var _mainScreen:Sprite;
		
		private var _isMoving:Boolean = false;
        private var _isPaused:Boolean;  // период когда камера не действует, а вместо этого действует эффекто сотрясания, к примеру.
		private var distX:Number;
		private var distY:Number;

        private var _stageCentralX:Number;
        private var _stageCentralY:Number;
        private var _playerPointX:Number;
        private var _playerPointY:Number;

        private var up:Boolean;
        private var left:Boolean;
        private var right:Boolean;
        private var down:Boolean;

        private var _levelWidth:int;
        private var _levelHeight:int;

        private var stageCentralPoint:Point = new Point(DistantColony.WIDTH/2, DistantColony.HEIGHT/2);

		
		/* ПАРАМЕТРЫ
			stage:Stage - сцена приложения
			player:DisplayObject - объект к которому привязывается камера
			fixPoint:Point - изначальная точка координат объекта (player.x, player.y),
							к которой будет постоянно тянуться камера
			speedFactor - коэффициент скорости камеры 
					(от 0.05 (очень медленно) до 1(камера просто движется за объектом))
		*/

		
		/* CONSTRUCTOR */
		public function MapMover (stage:Stage, target:Sprite, movingSprite:Sprite,
								  fixPoint:Point, speedFactor:Number)
		{
			_target = target;
			_stage = stage;
            _movingSprite = movingSprite;
            _levelWidth = _movingSprite.width/*/Platformer.SCALE_FACTOR*/;
            _levelHeight = _movingSprite.height/*/Platformer.SCALE_FACTOR*/;
			_fixPoint = fixPoint;
            globalPlayerPoint = new Point(_target.x, _target.y);
            _stageCentralX = stageCentralPoint.x;
            _stageCentralY = stageCentralPoint.y;
            _playerPointX = globalPlayerPoint.x;
            _playerPointY = globalPlayerPoint.y;
			_speedFactor = speedFactor;

		}

        /* CAMERA LOOP */
		public function cameraLoop():void
		{
            if(!_isPaused)
            {
                globalPlayerPoint = new Point(_target.x, _target.y);
                // проверка на столкновение стен сцены со стенами карты
                checkBordersCollission();
                checkOri();

                distX = distanceX(_stageCentralX, _playerPointX);
                distY = distanceY(_stageCentralY, _playerPointY);
                // передвижение камеры
                moveCameraX();
                moveCameraY();
            }
		}

        /* PAUSE */
        // временно отключается
        public function pause(duration:Number):void
        {
            _isPaused = true;
            var timer:Timer = new Timer(duration, 1);
            timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleted);
            timer.start();

            function timerCompleted(e:TimerEvent):void
            {
                _isPaused = false;
                timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerCompleted);
                timer = null;
            }
        }


        private function checkOri():void
        {
            if(up)
            {
                if(left)
                {
                    _playerPointX = _movingSprite.x + _stageCentralX;
                    _playerPointY = _movingSprite.y + _stageCentralY;
                }
                else if(right)
                {
                    _playerPointX = _levelWidth - _stageCentralX;
                    _playerPointY = _movingSprite.y + _stageCentralY;
                }
                else
                {
                    _playerPointX = globalPlayerPoint.x;
                    _playerPointY = _movingSprite.y + _stageCentralY;
                }
            }
            else if(down)
            {
                if(left)
                {
                    _playerPointX = _movingSprite.x + _stageCentralX;
                    _playerPointY = _levelHeight - _stageCentralY;
                }
                else if(right)
                {
                    _playerPointX = _levelWidth - _stageCentralX;
                    _playerPointY = _levelHeight - _stageCentralY;
                }
                else
                {
                    _playerPointX = globalPlayerPoint.x;
                    _playerPointY = _levelHeight - _stageCentralY;
                }
            }
            else if(left)
            {
                if(up)
                {
                    _playerPointX = _movingSprite.x + _stageCentralX;
                    _playerPointY = _movingSprite.y + _stageCentralY;
                }
                else if(down)
                {
                    _playerPointX = _movingSprite.x + _stageCentralX;
                    _playerPointY = _levelHeight - _stageCentralY;
                }
                else
                {
                    _playerPointX = _movingSprite.x + _stageCentralX;
                    _playerPointY = globalPlayerPoint.y;
                }
            }
            else if(right)
            {
                if(up)
                {
                    _playerPointX = _levelWidth - _stageCentralX;
                    _playerPointY = _movingSprite.y + _stageCentralY;
                }
                else if(down)
                {
                    _playerPointX = _levelWidth - _stageCentralX;
                    _playerPointY = _levelHeight - _stageCentralY;
                }
                else
                {
                    _playerPointX = _levelWidth - _stageCentralX;
                    _playerPointY = globalPlayerPoint.y;
                }
            }
            else
            {
                _playerPointX = globalPlayerPoint.x;
                _playerPointY = globalPlayerPoint.y;
            }
        }
		
        /* CHECK BORDERS COLLISIONS */
		private function checkBordersCollission():void
		{
			// если сцена касается левого края карты...
			if(_stage.x <= _movingSprite.x)
			{
				// ...и игрок находится левее центра сцены
				if(globalPlayerPoint.x <= _stageCentralX)
				{
                    left = true;
				}
				// ...и если игрок ушёл правее центра сцены
                else
				{
                    left = false;
				}
			}
			// если сцена касается правого края карты...
			if(_movingSprite.x + _levelWidth/**Platformer.SCALE_FACTOR*/ <= _stage.stageWidth)
			{
				// ...и игрок находится правее центра сцены
				if (globalPlayerPoint.x > _levelWidth-_stageCentralX)
				{
                    right = true;
				}
				
				// ...и если игрок ушёл левее центра сцены
				else
				{
                    right = false;
				}
			}
            // если сцена касается ВЕРХнего края карты...
			if(_stage.y <= _movingSprite.y)
			{
				// ...и игрок находится выше центра сцены
				if (globalPlayerPoint.y < _stageCentralY)
				{
                    up = true;
				}
				
				// ...и если игрок ушёл ниже центра сцены
				else
				{
                    up = false;
				}
			}
            // если сцена касается НИЖнего края карты...
			if(_stage.y + _stage.stageHeight/**Platformer.SCALE_FACTOR*/ >=  _stage.height)
			{
				// ...и игрок находится ниже центра сцены
				if (globalPlayerPoint.y > _levelHeight-_stageCentralY)
				{
                    down = true;
				}
				
				// ...и если игрок ушёл выше центра сцены
				else
				{
                    down = false;
				}
			}
		}
		
        /* MOVE CAMERA */
    private var _tweenX:TweenMax;
    private var _tweenY:TweenMax;
		private function moveCameraX():void
		{
            _tweenX = new TweenMax(_movingSprite, 0.5, {x:distX/**Platformer.SCALE_FACTOR*/});
			if (globalPlayerPoint.x != _fixPoint.x)
//			if (!left && !right)
			{
                _tweenX.play();
			}
            else
            {
                _tweenX.kill();
            }
		}

        private function moveCameraY():void
        {
            _tweenY = new TweenMax(_movingSprite, 0.5, {y:distY/**Platformer.SCALE_FACTOR*/});
            if (globalPlayerPoint.y != _fixPoint.y)
            {
                _tweenY.play();
            }
            else
            {
                _tweenY.kill();
            }
        }

        /* DISTANCE X Y */
		// функции расчёта расстояния по Х и У
		private function distanceX(x1:Number, x2:Number):Number
		{
			var dx:Number = x1-x2;
			return dx;
		}
		
		private function distanceY(y1:Number, y2:Number):Number
		{
			var dy:Number = y1-y2;
			return dy;
		}
		

		// speed factor
		public function get speedFactor():Number
		{
			return _speedFactor;
		}

		public function set speedFactor(value:Number):void
		{
			if (value < 0.05)
			{
				value = 0.05;
				_speedFactor = value;
			}
			else if (value > 1)
			{
				value = 1;
				_speedFactor = value;
			}
			
		}
		

		/* GET & SET */
		public function get speedX():Number{return _speedX;}
		public function set speedX(value:Number):void{_speedX = value;}

        public function get speedY():Number{return _speedY;}
		public function set speedY(value:Number):void{_speedY = value;}

		public function get globalPlayerPoint():Point{return _globalPlayerPoint;}
		public function set globalPlayerPoint(value:Point):void{_globalPlayerPoint = value;}

		public function get fixPoint():Point{return _fixPoint;}
		public function set fixPoint(value:Point):void{_fixPoint = value;}

    public function get isPaused():Boolean {
        return _isPaused;
    }

    public function set isPaused(value:Boolean):void {
        _isPaused = value;
    }
}
}





