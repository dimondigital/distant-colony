/**
 * Created by Sith on 05.08.14.
 */
package MVC.players
{
import MVC.GameModel;

import level.LevelObject;


public interface IPlayer
{
    function move():void
    function get model():PlayerModel
    function deactivateInterface():void
    function activateInterface():void
    function initStartContent():void
    function initGameModel(gameModel:GameModel):void
    function initLevelObject(lo:LevelObject):void
}
}
