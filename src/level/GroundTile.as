/**
 * Created by Sith on 04.08.14.
 */
package level {
import cv.Orion;
import cv.orion.filters.ColorFilter;
import cv.orion.filters.ScaleFilter;
import cv.orion.output.BurstOutput;

import flash.display.Sprite;
import flash.geom.Rectangle;

public class GroundTile extends Sprite
{
    private var _view:McGroundTile;
    private var _groundType:int;
    private var _value:Value;
    private var _isFull:Boolean; // наполнен ли
    private var _isExplored:Boolean; // разведан ли
    private var _isDigged:Boolean;  // раскопан ли
    private var _inVisionRange:Boolean; // в поле зрения
    private var _isAlreadyUpdated:Boolean;

    private var _wIndex:int;
    private var _hIndex:int;

    private var _visibleState:int;
    private var _groundDark:McGroundTileDark;
    public static const VISIBLE:int = 1;
    public static const HALF_DARKED:int = 2;
    public static const DARKED:int = 3;

    public static const LAYER_1:int = 1;
    public static const LAYER_2:int = 2;
    public static const LAYER_3:int = 3;
    public static const LAYER_4:int = 4;

    private var _selectorType:int;
    public static const SELECT_NONE:int = 0;
    public static const SELECT_TEMP:int = 1;
    public static const SELECT_GREEN:int = 2;
    public static const SELECT_WRONG:int = 3;

    private var _particleColors:Array = [0xC15912, 0x858285, 0x007979, 0xB41217];

    private var _valueView:McValue;

    private var _walkPoints:int;

    private var _tempView:McTempPath;
    private var _wrongView:McWrongPath;
    private var _greenView:McGreenSelector;

    private var _darkLayer:Sprite;
    private var _selectorLayer:Sprite;
    private var _valueLayer:Sprite;
    private var _particleLayer:Sprite;

    private var _clickCounter:int = 0;

    /*CONSTRUCTOR*/
    public function GroundTile(x:Number, y:Number, yOffset:Number, groundType:int, wIndex:int, hIndex:int, value:Value)
    {
        _groundType = groundType;
        _isFull = true;
        _view = new McGroundTile();
        _wIndex = wIndex;
        _hIndex = hIndex;
        _value = value;
        _view.stop();
        _groundDark = new McGroundTileDark();
        updateView();
        if(_value != null)
        {
            _valueView  = new McValue();
            _valueView.gotoAndStop(groundType + (4 * (value.fulledType-1)));
            _valueView.x = x;
            _valueView.y = y + yOffset;
//            _valueView.mouseChildren = false;
//            _valueView.mouseEnabled = false;
        }

        _view.x = x;
        _view.y = y +yOffset;
        _groundDark.x = x;
        _groundDark.y = y + yOffset;

        _tempView = new McTempPath();
        _tempView.x = x;
        _tempView.y = y + yOffset;

        _wrongView = new McWrongPath();
        _wrongView.x = x;
        _wrongView.y = y + yOffset;

        _greenView = new McGreenSelector();
        _greenView.x = x;
        _greenView.y = y;

        _selectorType = SELECT_NONE;
    }

    /* UPDATE VIEW */
    private function updateView():void
    {
        if(_groundType == -1) _view.gotoAndStop(10);             // не бурящаяся земля
        if(_groundType == 0)
        {
            _view.gotoAndStop(9);
            _view.alpha = 0;  // не занятый землёй тайл
        }
        if(_groundType == 1) _view.gotoAndStop(1 + int(_isFull));
        if(_groundType == 2) _view.gotoAndStop(3 + int(_isFull));
        if(_groundType == 3) _view.gotoAndStop(5 + int(_isFull));
        if(_groundType == 4) _view.gotoAndStop(7 + int(_isFull));

        if(!_isFull)
        {
            if(_valueView != null)
            {
                _valueLayer.removeChild(_valueView);
                _valueView = null;
            }
        }
    }

    public function get view():McGroundTile {return _view;}

    public function get visibleState():int {return _visibleState;}
    public function set visibleState(value:int):void
    {
        _visibleState = value;
//        _groundDark.visible = true;
        if(_visibleState == DARKED)
        {
            _groundDark.alpha = 0.99;
            _groundDark.visible = true;
        }
        else if(_visibleState == HALF_DARKED)
        {
            _groundDark.alpha = 0.5;
            _groundDark.visible = true;
        }
        else
        {
            _groundDark.alpha = 0;
            _groundDark.visible = false;
        }
    }

    /* DIG */
    public function dig():void
    {
        _isFull = false;
        addParticles();
        updateView();
    }

    /* ADD PARTICLES */
    private var _particleSettings:Object = {lifeSpan:1500, alphaMin:1, alphaMax:0, scaleMax:0.7, scaleMin:0.1};
//    private var _particleSettings:Object = {};
    private function addParticles():void
    {
        var treasureColor:uint = uint(_particleColors[_groundType-1]);
        var particleEffectFilters:Object = [ new ScaleFilter(0.95),/* new WanderFilter(0.5, 0.5),*/ new ColorFilter(treasureColor)];
        var o:Orion = new Orion(ImgDust, new BurstOutput(50, false), {settings:_particleSettings, effectFilters:particleEffectFilters, useCacheAsBitmap:true}, true);
        o.canvas = new Rectangle(0, 0, 16, 16);
        o.x = view.x;
        o.y = view.y;
        o.width = 16;
        o.height = 16;
        _particleLayer.addChild(o);
    }

    public function get isAlreadyUpdated():Boolean {return _isAlreadyUpdated;}
    public function set isAlreadyUpdated(value:Boolean):void {_isAlreadyUpdated = value;}

    public function get isExplored():Boolean {return _isExplored;}
    public function set isExplored(value:Boolean):void {_isExplored = value;}

    public function get darkLayer():Sprite {return _darkLayer;}
    public function set darkLayer(value:Sprite):void
    {
        _darkLayer = value;
        _darkLayer.addChild(_groundDark);
    }

    public function get wIndex():int {
        return _wIndex;
    }

    public function get hIndex():int {
        return _hIndex;
    }

    public function get groundType():int {
        return _groundType;
    }

    public function get clickCounter():int {
        return _clickCounter;
    }

    public function set clickCounter(value:int):void {
        _clickCounter = value;
    }

    public function get isDigged():Boolean {
        return _isDigged;
    }

    public function get inVisionRange():Boolean {
        return _inVisionRange;
    }

    public function set inVisionRange(value:Boolean):void {
        _inVisionRange = value;
    }

    public function get valueLayer():Sprite {
        return _valueLayer;
    }

    public function set valueLayer(value:Sprite):void
    {
        _valueLayer = value;
        if(_value) _valueLayer.addChild(_valueView);
    }

    public function get particleLayer():Sprite {
        return _particleLayer;
    }

    public function set particleLayer(value:Sprite):void {
        _particleLayer = value;
    }

    public function get value():Value {
        return _value;
    }

    public function get walkPoints():int {
        return _walkPoints;
    }

    public function set walkPoints(value:int):void {
        _walkPoints = value;
    }

    public function get selectorType():int {
        return _selectorType;
    }

    /* SET SELECTOR TYPE */
    public function setSelectorType(selectType:int, selectorLayer:Sprite):void
    {
        if(_selectorLayer == null) _selectorLayer = selectorLayer;
        _selectorType = selectType;
        switch (selectType)
        {
            case SELECT_NONE:
                if(_tempView) _tempView.visible = false;
                if(_greenView) _greenView.visible = false;
                if(_wrongView) _wrongView.visible = false;
                break;
            case SELECT_TEMP:
                if(_tempView) _tempView.visible = true;
                if(_greenView) _greenView.visible = false;
                if(_wrongView) _wrongView.visible = false;
                    _selectorLayer.addChild(_tempView);
                    _tempView.tf.text = walkPoints.toString();

                _tempView.mouseChildren = false;
                _tempView.mouseEnabled = false;
                break;
            case SELECT_GREEN:
                if(_tempView) _tempView.visible = false;
                if(_greenView) _greenView.visible = true;
                if(_wrongView) _wrongView.visible = false;
                    _selectorLayer.addChild(_greenView);
                _greenView.mouseChildren = false;
                _greenView.mouseEnabled = false;
                break;
            case SELECT_WRONG:
                if(_tempView) _tempView.visible = false;
                if(_greenView) _greenView.visible = false;
                if(_wrongView) _wrongView.visible = true;
                _selectorLayer.addChild(_wrongView);
                _wrongView.mouseChildren = false;
                _wrongView.mouseEnabled = false;
                break;
        }
    }

    public function set isDigged(value:Boolean):void {
        _isDigged = value;
    }

    public function get isFull():Boolean {
        return _isFull;
    }
}
}
