/**
 * Created by Sith on 09.08.14.
 */
package actions
{
import MVC.GameView;
import MVC.buildings.ABuilding;
import MVC.players.PlayerModel;

import flash.display.MovieClip;
import flash.events.MouseEvent;

import level.Value;

public class Build extends Action
{
    private var _buildView:MovieClip;
    private var _gameView:GameView;
    private var _buildings:Vector.<ABuilding>;
    private var _resources:Array;

    /*CONSTRUCTOR*/
    public function Build(buildView:MovieClip, type:String, name:String, cost:Value, isAval:Boolean, isExplored:Boolean, callbackAction:Function, gameView:GameView, buildings:Vector.<ABuilding>, resources:Array)
    {
        _buildView = buildView;
        _gameView = gameView;
        _buildings = buildings;
        _resources = resources;
        super(type, name, cost, isAval, isExplored, callbackAction);
    }

    /* ADD LISTENERS */
    protected override function addListeners():void
    {
        _view.addEventListener(MouseEvent.CLICK, onClick);
        _view.addEventListener(MouseEvent.MOUSE_OVER, onOver);
        _view.addEventListener(MouseEvent.MOUSE_OUT, onOut);
    }

    /* REMOVE LISTENERS */
    protected function removeListeners():void
    {
        _view.removeEventListener(MouseEvent.CLICK, onClick);
        _view.removeEventListener(MouseEvent.MOUSE_OVER, onOver);
        _view.removeEventListener(MouseEvent.MOUSE_OUT, onOut);
    }

    /* MOUSE OVER */
    private function onOver(e:MouseEvent):void
    {
        // строим здания справа от последнего в списке
        var lastBuilding:ABuilding = _buildings[_buildings.length-1];
        _buildView.alpha = 0.5;
        _buildView.x = lastBuilding.view.x + lastBuilding.view.width + DistantColony.TILE_SIZE;
        _buildView.y = (DistantColony.TILE_SIZE * 7) - _buildView.height;
        _gameView.buildLingLayer.addChild(_buildView);
    }

    /* MOUSE OUT */
    private function onOut(e:MouseEvent):void
    {
        _gameView.buildLingLayer.removeChild(_buildView);
    }

    /* ON CLICK */
    protected override function onClick(e:MouseEvent):void
    {
        if(!isExplored)
        {
            if(PlayerModel.enoughResources(this, _resources))
            {
                removeListeners();
                _buildView.alpha = 1;
                _callbackAction(this);
            }
        }
    }

    public function get buildView():MovieClip {return _buildView;}
}
}
