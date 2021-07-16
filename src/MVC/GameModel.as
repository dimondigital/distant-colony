/**
 * Created by Sith on 04.08.14.
 */
package MVC
{
import MVC.players.IPlayer;

public class GameModel implements IGameModel
{
    private var _view:IGameView;
    private var _players:Vector.<IPlayer>;

    private var _currentSelected:AContent;
    private var _attackedContent:AContent;

    public static const PLAYER_ID:int = 1;
    public static const BOT_ID:int = 2;

    /*CONSTRUCTOR*/
    public function GameModel(view:IGameView, players:Vector.<IPlayer>)
    {
        _view = view;
        _players = players;
    }

    public function get currentSelected():AContent {return _currentSelected;}
    public function set currentSelected(value:AContent):void
    {
        _currentSelected = value;
    }

    public function get players():Vector.<IPlayer> {
        return _players;
    }

    public function get attackedContent():AContent {return _attackedContent;}
    public function set attackedContent(value:AContent):void {_attackedContent = value;}
}
}
