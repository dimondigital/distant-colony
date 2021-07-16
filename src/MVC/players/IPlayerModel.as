/**
 * Created by Sith on 05.08.14.
 */
package MVC.players
{
import MVC.AContent;

public interface IPlayerModel
{
    function initInterface(view:IPlayerView):void
    function initStartContent():void
    function get contents():Vector.<AContent>
}
}
