/**
 * Created by Sith on 05.08.14.
 */
package MVC.players
{
import MVC.GameModel;

import flash.events.TimerEvent;
import flash.utils.Timer;

import level.LevelObject;

public class Bot extends APlayer implements IPlayer
{
    private var _botTimer:Timer;

    /*CONSTRUCTOR*/
    public function Bot(endMoveCallback:Function, playerModel:PlayerModel)
    {
        super(endMoveCallback, playerModel);

    }

    /* INIT START CONTENT */
    public function initStartContent():void
    {
        model.initStartContent();
    }

    /* INIT GAME MODEL */
    public function initGameModel(gameModel:GameModel):void
    {

    }

    /* INIT LEVEL OBJECT */
    public function initLevelObject(lo:LevelObject):void
    {

    }

    /* MOVE */
    public function move():void
    {
        trace("BOT : move");
//        think();
        endMove();
    }

    /* THINK */
    private function think():void
    {
        _botTimer = new Timer(3000, 1);
        _botTimer.addEventListener(TimerEvent.TIMER_COMPLETE, timerEnd);
        _botTimer.start();
    }

    /* TIMER END */
    private function timerEnd(e:TimerEvent):void
    {
        _botTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerEnd);
        endMove();
    }

    /* DEACTIVATE INTERFACE */
    public function deactivateInterface():void
    {

    }

    /* ACTIVATE INTERFACE */
    public function activateInterface():void
    {

    }

    public function get model():PlayerModel {return _model;}
}
}
