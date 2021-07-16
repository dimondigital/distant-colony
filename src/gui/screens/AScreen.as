/**
 * Created by Sith on 31.03.14.
 */
package gui.screens
{
import flash.display.MovieClip;
import flash.events.Event;

public class AScreen extends MovieClip implements IScreen, IScaled
{
    protected var _view:MovieClip;
    protected var _nextScreen:IScreen;
    protected var _isShowingMouseCursor:Boolean;
    protected var _screenName:String;

    private var _isScalable:Boolean;

    public function AScreen(screenName:String, view:MovieClip, nextScreen:IScreen, isShowingMouseCursor:Boolean, isScalable:Boolean=true)
    {
        _screenName = screenName;
        _view = view;
        _nextScreen = nextScreen;
        _isShowingMouseCursor = isShowingMouseCursor;
        _isScalable = isScalable;

        _view.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
    }

    /* SCALE */
    public function scale():void
    {
        if(_isScalable) _view.scaleX = _view.scaleY = DistantColony.SCALE_FACTOR;
    }

    /* ADDED TO STAGE */
    private function addedToStageHandler(e:Event):void
    {
        scale();
        _view.addEventListener(Event.ENTER_FRAME, exitFrameListener);
        _view.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
    }

    /* EXIT FRAME LISTENER */
    protected function exitFrameListener(e:Event):void
    {
        if(_view.currentFrame == _view.totalFrames)
        {
            _view.removeEventListener(Event.ENTER_FRAME, exitFrameListener);
            if(_nextScreen) ScreenManager.show(_nextScreen.screenName);
        }
    }

    /* DEACTIVATE */
    public function deactivate():void
    {

    }

    /* PREPARE */
    public function prepare():void
    {

    }

    public function gotoStartPos():void
    {
        _view.gotoAndPlay(1);
    }

    /* GETTERS & SETTERS */
    public function get isShowingMouseCursor():Boolean {return _isShowingMouseCursor;}

    public function get view():MovieClip {return _view;}

    public function get screenName():String {return _screenName;}
}
}
