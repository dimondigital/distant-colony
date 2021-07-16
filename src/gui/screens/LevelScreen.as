/**
 * Created by Sith on 31.03.14.
 */
package gui.screens
{
import MVC.GameController;
import flash.display.Bitmap;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.ui.Mouse;
import sound.SoundManager;

public class LevelScreen extends AScreen
    {
        private var _gameController:GameController;

        private var _stage:Stage;
        private var _totalScreen:Sprite;

        /* CONSTRUCTOR */
        public function LevelScreen(screenName:String, view:MovieClip, isShowingMouseCursor:Boolean, stage:Stage, totalScreen:Sprite)
        {
            super(screenName, view, null, isShowingMouseCursor);
            _isShowingMouseCursor = isShowingMouseCursor;
            _stage = stage;
            _totalScreen = totalScreen;
            _view.addEventListener(Event.ADDED_TO_STAGE, init);
        }

        /* INIT */
        private function init(e:Event):void
        {
            trace("LEVEL : init");
            _view.removeEventListener(Event.ADDED_TO_STAGE, init);

            _gameController = new GameController(_stage);
            _view.addChild(_gameController);

            _gameController.init();
        }

        /* DEACTIVATE */
        public override function deactivate():void
        {
            trace("level screen deactivate");

            _view.removeChild(_gameController);
            _gameController = null;

            SoundManager.stopAllSounds();
        }

}
}
