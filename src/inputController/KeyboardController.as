/**
 * Created by Sith on 11.06.14.
 */
package inputController
{
import camera.MovableModel;
import flash.display.Stage;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;

public class KeyboardController
{
    private var _playerModel:MovableModel;

    private var _left:int;
    private var _right:int;
    private var _up:int;
    private var _down:int;

    private var _stage:Stage;

    public function KeyboardController(playerModel:MovableModel, stage:Stage)
    {
        _playerModel = playerModel;
        _stage = stage;

        _left = Keyboard.LEFT;
        _down = Keyboard.DOWN;
        _right = Keyboard.RIGHT;
        _up = Keyboard.UP;

        _stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
        _stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
    }

    /* ON KET DOWN */
    private function onKeyDown(e:KeyboardEvent):void
    {
        switch (e.keyCode)
        {
            case _left:
                _playerModel.isLeft = true;
                break;
            case _right:
                _playerModel.isRight = true;
                break;
            case _down:
                _playerModel.isDown = true;
                break;
            case _up:
                _playerModel.isUp = true;
                break;
        }
    }

    /* ON KET UP */
    private function onKeyUp(e:KeyboardEvent):void
    {
        switch (e.keyCode)
        {
            case _left:
                _playerModel.isLeft = false;
                break;
            case _up:
                _playerModel.isUp = false;
                break;
            case _right:
                _playerModel.isRight = false;
                break;
            case _down:
                _playerModel.isDown = false;
                break;
        }
    }
}
}
