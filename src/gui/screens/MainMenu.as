/**
 * Created by Sith on 28.01.14.
 */
package gui.screens
{
import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.Event;
import flash.events.MouseEvent;

public class MainMenu extends AScreen
{
    public static const BTN_NEW_GAME:String = "btnStartGame";
    public static const BTN_RESUME:String = "btn_resume";
    public static const BTN_OPTIONS:String = "btn_options";
    public static const BTN_ACHIVMENTS:String = "btn_achivments";
    public static const BTN_CREDITS:String = "btn_credits";

    /* CONSTRUCTOR */
    public function MainMenu(screenName:String, view:MovieClip, isShowingMouseCursor:Boolean)
    {
        super(screenName, view, null, isShowingMouseCursor);
        _screenName = screenName;
        _isShowingMouseCursor = isShowingMouseCursor;
        _view.addEventListener(Event.ADDED_TO_STAGE, init);
    }

    /* INIT */
    private function init(e:Event):void
    {
        trace("MAIN : init");

        _view.removeEventListener(Event.ADDED_TO_STAGE, init);

        _view.addEventListener(MouseEvent.CLICK, onClick);
    }

    /* ON CLICK */
    private function onClick(e:MouseEvent):void
    {
        if(e.target is SimpleButton)
        {
            switch(DisplayObject(e.target).name)
            {
                case BTN_NEW_GAME:
                       ScreenManager.show(ScreenManager.LEVEL_SCREEN);
                  break;
            }
        }

    }

    /* DEACTIVATE */
    public override function deactivate():void
    {

    }
}
}
