/**
 * Created by Sith on 05.08.14.
 */
package MVC.players
{
public class APlayer
{
    private var _endMoveCallback:Function;
    protected var _model:PlayerModel;

    /*CONSTRUCTOR*/
    public function APlayer(endMoveCallback:Function, playerModel:PlayerModel)
    {
        _endMoveCallback = endMoveCallback;
        _model = playerModel;
    }

    /* END MOVE */
    protected function endMove():void
    {
        _endMoveCallback.call();
    }
}
}
