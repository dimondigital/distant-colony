/**
 * Created by Sith on 05.08.14.
 */
package MVC.players
{
import MVC.GameModel;
import MVC.GameView;

import gui.gameInterface.GameInterface;

import level.LevelObject;

public class Player extends APlayer implements IPlayer
{
    private var _gameInterface:GameInterface;

    /*CONSTRUCTOR*/
    public function Player(endMoveCallback:Function, playerModel:PlayerModel, _gameView:GameView, levelObject:LevelObject)
    {
        super(endMoveCallback, playerModel);
        _gameInterface = new GameInterface(playerModel, _gameView, endMoveCallback, levelObject);
    }

    /* MOVE */
    public function move():void
    {
        trace("PLAYER : move");
        // update walk points
        _model.walkPoints = 10;
    }

    /* INIT GAME MODEL */
    public function initGameModel(gameModel:GameModel):void
    {
        _gameInterface.initGameModel(gameModel);
    }

    /* INIT GAME MODEL */
    public function initLevelObject(lo:LevelObject):void
    {
        _gameInterface.initLevelObject(lo);
    }

    /* INIT START CONTENT */
    public function initStartContent():void
    {
        model.initStartContent();
    }

    /* DEACTIVATE INTERFACE */
    public function deactivateInterface():void
    {
        _gameInterface.deactivate();
    }

    /* ACTIVATE INTERFACE */
    public function activateInterface():void
    {
        _gameInterface.activate();
    }
    public function get model():PlayerModel {return _model;}

}
}
