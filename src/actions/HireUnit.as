/**
 * Created by Sith on 09.08.14.
 */
package actions
{
import MVC.GameView;
import MVC.buildings.ABuilding;
import MVC.buildings.RobotFactory;
import MVC.players.PlayerModel;

import flash.display.MovieClip;
import flash.events.MouseEvent;

import level.Value;

public class HireUnit extends Action
{
    private var _buildView:*;
    private var _gameView:GameView;
    private var _buildings:Vector.<ABuilding>;
    private var _resources:Array;

    /*CONSTRUCTOR*/
    public function HireUnit(buildView:*, type:String, name:String, cost:Value, isAval:Boolean, isExplored:Boolean, callbackAction:Function, gameView:GameView, buildings:Vector.<ABuilding>, resources:Array)
    {
        _buildView = buildView;
        _gameView = gameView;
        _buildings = buildings;
        _resources = resources;

        super(type, name, cost, isAval, isExplored, callbackAction);
    }

    /* ON CLICK */
    protected override function onClick(e:MouseEvent):void
    {
        if(isAval)
        {
            if(PlayerModel.enoughResources(this, _resources))
            {
                var building:RobotFactory;
                for each(var b:ABuilding in _buildings)
                {
                    if(b is RobotFactory) building = RobotFactory(b);
                }
                _buildView = new _buildView();
                _buildView.x = building.view["unit"].x + building.view.x;
                _buildView.y = building.view["unit"].y + building.view.y;
                _gameView.unitLayer.addChild(_buildView);
                _callbackAction(this);
            }
        }
    }

    public function get buildView():MovieClip {return MovieClip(_buildView);}
}
}
