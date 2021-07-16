/**
 * Created by Sith on 05.08.14.
 */
package MVC
{
import events.SelectEvent;

import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.utils.Timer;

/* класс, представляющий общую сущность для здания и юнита */
public class AContent extends MovieClip implements IVisionRange, ISelectable
{
    private var _visionRange:int;
    private var _health:int;
    private var _view:MovieClip;
    private var _id:int;
    private var _isSelectable:Boolean = true;
    private var _internalView:MovieClip;
    private var _offsetX:int;
    private var _offsetY:int;

    private var _currentFrameLabel:ClipLabel;
    private var _clipLabels:Vector.<ClipLabel>;

    /*CONSTRUCTOR*/
    public function AContent(visionRange:int, health:int, view:MovieClip, id:int)
    {
        _visionRange = visionRange;
        _health = health;
        _view = view;
        _id = id;

        _isSelectable = true;


        _view.addEventListener(MouseEvent.CLICK, onMouseClick);
//        _view.addEventListener(Event.ADDED_TO_STAGE, addedToStage);
    }

    /* ADDED TO STAGE */
//    private function addedToStage(e:Event):void
//    {
//        _view.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
//        _view.addEventListener(MouseEvent.CLICK, onMouseClick);
//    }

    /* ON MOUSE CLICK */
    public function onMouseClick(e:MouseEvent):void
    {
//        trace("AContent : need to override this function");
        if(_isSelectable)
        {
            view.dispatchEvent(new SelectEvent(this, SelectEvent.SELECT, true));
        }
    }

    /***************************** PLAY ANIMATION *******************************************************/

    // Глобальный вызов анимации
    /* PLAY STATE */
    private var _frameTimer:Timer;
    public function playState(labelName:String, callback:Function=null, nextLabel:String=null):void
    {
        if(!checkCurrentFrameLabel(labelName))
        {
            loopState(labelName, callback, nextLabel);
        }
    }
    // локальный вызов анимации
    /* LOOP STATE */
    private function loopState(labelName:String, callback:Function=null, nextLabel:String=null):void
    {
        _currentFrameLabel = getLabelByName(labelName);
        if(nextLabel) _currentFrameLabel.nextLabel = nextLabel;
        if(callback) _currentFrameLabel.callbackFunction = callback;
        if(_frameTimer)
        {
            _frameTimer.stop();
            if(_frameTimer.hasEventListener(TimerEvent.TIMER))
            {
                _frameTimer.removeEventListener(TimerEvent.TIMER, timerCount);
            }
            if(_frameTimer.hasEventListener(TimerEvent.TIMER_COMPLETE))
            {
                _frameTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, endTimer);
            }
            _frameTimer = null;
        }
        if(_internalView) _internalView.gotoAndStop(_currentFrameLabel.name);
        else             _view.gotoAndStop(_currentFrameLabel.name);
        if(_currentFrameLabel.labelTotalFrames > 1)
        {
            var delay:Number = _currentFrameLabel.animationSpeed/(_currentFrameLabel.labelTotalFrames);
            _frameTimer = new Timer(delay*1000, _currentFrameLabel.labelTotalFrames);
            _frameTimer.addEventListener(TimerEvent.TIMER, timerCount);
            _frameTimer.addEventListener(TimerEvent.TIMER_COMPLETE, endTimer);
            _frameTimer.start();
        }
    }

    /* TIMER COUNT */
    private function timerCount(e:TimerEvent):void
    {
        if(_internalView) _internalView.nextFrame();
        else              _view.nextFrame();
    }
    /* END TIMER */
    private function endTimer(e:TimerEvent):void
    {
        _frameTimer.stop();
        _frameTimer.removeEventListener(TimerEvent.TIMER, timerCount);
        _frameTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, endTimer);
        _frameTimer = null;
        gotoStartLabel();
    }
    /* GOTO START LABEL */
    private function gotoStartLabel():void
    {
        if(!_currentFrameLabel.callbackFunction)
        {
            if(_currentFrameLabel.nextLabel)
            {
                loopState(_currentFrameLabel.nextLabel);
            }
            else
            {
                loopState(_currentFrameLabel.name);
            }
        }
        else
        {
//            _currentFrameLabel.callbackFunction(controlledObject);
            _currentFrameLabel.callbackFunction();
        }
    }

    /* GET LABEL BY NAME */
    private function getLabelByName(labelName:String):ClipLabel
    {
        for each(var label:ClipLabel in _clipLabels)
        {
            if(label.name == labelName)
            {
                return label;
            }
        }
        return null;
    }

    /* CHECK CURRENT FRAME LABEL */
    public function checkCurrentFrameLabel(label:String):Boolean
    {
        if(_currentFrameLabel) return (label == _currentFrameLabel.name);
        else return false;
    }

    public function get visionRange():int {return _visionRange;}

    public function get view():MovieClip {return _view;}

    public function get id():int {return _id;}

    public function get isSelectable():Boolean {return _isSelectable;}
    public function set isSelectable(value:Boolean):void {_isSelectable = value;}

    public function get offsetX():int {return _offsetX;}
    public function set offsetX(value:int):void {_offsetX = value;}

    public function get offsetY():int {return _offsetY;}
    public function set offsetY(value:int):void {_offsetY = value;}

    public function get internalView():MovieClip {return _internalView;}
    public function set internalView(value:MovieClip):void {_internalView = value;}

    public function get clipLabels():Vector.<ClipLabel> {return _clipLabels;}
    public function set clipLabels(value:Vector.<ClipLabel>):void {_clipLabels = value;}

    public function set visionRange(value:int):void {_visionRange = value;}

    public function get health():int {
        return _health;
    }

    public function set health(value:int):void {
        _health = value;
    }
}
}
