/**
 * Created by Sith on 05.08.14.
 */
package gui.gameInterface
{
import MVC.AContent;
import MVC.GameModel;
import MVC.GameView;
import MVC.buildings.ExplorerCenter;
import MVC.buildings.Headquaters;
import MVC.buildings.RobotFactory;
import MVC.players.IPlayerView;
import MVC.players.PlayerModel;
import MVC.units.Drill;

import actions.Action;

import events.SelectEvent;

import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;

import level.GroundTile;
import level.LevelObject;
import level.Value;

import loc.Locale;

public class GameInterface implements IPlayerView
{
    private var _playerModel:PlayerModel;
    private var _gameModel:GameModel
    private var _view:Sprite;
    private var _gameView:Sprite;

    private var _endMoveCallback:Function;
    private var _btnEndMove:SimpleButton;
    private var _moveCounter:McMovePoints;

    private var _tfSilicon:TextField;
    private var _tfAluminum:TextField;
    private var _tfTitanium:TextField;
    private var _tfGold:TextField;
    private var _tfTungsten:TextField;
    private var _tfRare:TextField;

    // info panel
    private var _infoIcon:McInfoIcon;
    private var _tfCaption:TextField;
    private var _tfDescription:TextField;
    private var _tfWarning:TextField;
    private var _costIcon_1:McMetalIcon;
    private var _costIcon_2:McMetalIcon;
    private var _costIcon_3:McMetalIcon;
    private var _costIcons:Array;

    private var _levelObject:LevelObject;

// explored panel
    private var _exploredPanel:MovieClip;

    /*CONSTRUCTOR*/
    public function GameInterface(playerModel:PlayerModel, gameView:GameView, endMoveCallback:Function, levelObject:LevelObject)
    {
        _playerModel = playerModel;
        _playerModel.initInterface(this);
        _gameView = gameView;
        _levelObject = levelObject;
        _endMoveCallback = endMoveCallback;

        _view = new McPlayerInterface();
        _btnEndMove = _view["btnEndMove"];
        _gameView.addChild(_view);

        // init metal panel
        _tfSilicon = _view["tf_Silicon"];
        _tfAluminum = _view["tf_Aluminum"];
        _tfTitanium = _view["tf_Titanium"];
        _tfGold = _view["tf_Gold"];
        _tfTungsten = _view["tf_Tungsten"];
        _tfRare = _view["tf_Rare"];

        // init move counter
        _moveCounter = _view["mcMovePoints"];

        // init info icon
        _infoIcon = _view["mc_InfoIcon"];
        _tfCaption = _view["tf_Caption"];
        _tfDescription = _view["tf_Description"];
        _tfWarning = _view["tf_Warning"];
        _costIcon_1 = _view["costActionIcon_1"];
        _costIcon_2 = _view["costActionIcon_2"];
        _costIcon_3 = _view["costActionIcon_3"];
        _costIcons = [_costIcon_1, _costIcon_2, _costIcon_3];
        updateCostIcons(false);

        // init explored panel
        _exploredPanel = _view["exploredPanel"];
        _exploredPanel["drill"].visible = false;
        _exploredPanel["hq"].visible = false;
        _exploredPanel["robotFactory"].visible = false;
        _exploredPanel["explorerCenter"].visible = false;

        _gameView.addEventListener(MouseEvent.MOUSE_MOVE, updateInfo);
        _gameView.addEventListener(SelectEvent.SELECT, updatedSelected);
    }

    /* INIT GAME MODEL */
    public function initGameModel(gameModel:GameModel):void
    {
        _gameModel = gameModel;
        initActionViews();
    }

    /* INIT LEVEL OBJECT */
    public function initLevelObject(lo:LevelObject):void
    {
        _levelObject = lo;
    }

    /* INIT ACTION VIEWS */
    private function initActionViews():void
    {
        for(var i:int = 0; i < _playerModel.actionKeys.length; i++)
        {
            var actionKey:String = _playerModel.actionKeys[i];
            var action:Action = _playerModel.actions[actionKey];
            var iconCont:Sprite = _exploredPanel[action.type];
            action.initView(iconCont[actionKey], iconCont);
        }
    }

    /* UPDATE SELECTED */
    private var _select:AContent;
    private function updatedSelected(e:SelectEvent=null):void
    {
        if(e) _select = e.selectedObject;
        var currentSelected:AContent = _gameModel.currentSelected;
        if(currentSelected)
        {
            // select
            if(_select is Drill)
            {
                setInfoFromLoc("drill");
                _exploredPanel["drill"].visible = true;
                _exploredPanel["hq"].visible = false;
                _exploredPanel["robotFactory"].visible = false;
                _exploredPanel["explorerCenter"].visible = false;
            }
            else if(_select is Headquaters)
            {
                setInfoFromLoc("hq");
                _exploredPanel["hq"].visible = true;
                _exploredPanel["drill"].visible = false;
                _exploredPanel["robotFactory"].visible = false;
                _exploredPanel["explorerCenter"].visible = false;
            }
            else if(_select is RobotFactory)
            {
                setInfoFromLoc("robotFactory");
                _exploredPanel["robotFactory"].visible = true;
                _exploredPanel["drill"].visible = false;
                _exploredPanel["hq"].visible = false;
                _exploredPanel["explorerCenter"].visible = false;
            }
            else if(_select is ExplorerCenter)
            {
                setInfoFromLoc("explorerCenter");
                _exploredPanel["explorerCenter"].visible = true;
                _exploredPanel["robotFactory"].visible = false;
                _exploredPanel["drill"].visible = false;
                _exploredPanel["hq"].visible = false;
            }
        }
        else if(currentSelected == null)
        {
            // deselect
            clearInfoPanel();
            _exploredPanel["drill"].visible = false;
            _exploredPanel["hq"].visible = false;
            _exploredPanel["robotFactory"].visible = false;
            _exploredPanel["explorerCenter"].visible = false;
        }
    }

    /* END MOVE */
    private function endMove(e:MouseEvent):void
    {
        _endMoveCallback.call();
    }

    /* DEACTIVATE INTERFACE */
    public function deactivate():void
    {
        _btnEndMove.removeEventListener(MouseEvent.CLICK, endMove);
        _btnEndMove.alpha = 0.5;
    }

    /* ACTIVATE INTERFACE */
    public function activate():void
    {
        _btnEndMove.addEventListener(MouseEvent.CLICK, endMove);
        _btnEndMove.alpha = 1;
    }

    /* UPDATE METAL PANEL */
    public function updateMetalPanel(metalName:String):void
    {
        switch (metalName)
        {
            case PlayerModel.SILICON:
                _tfSilicon.text = _playerModel.silicon.toString();
                break;
            case PlayerModel.ALUMINUM:
                _tfAluminum.text = _playerModel.aluminum.toString();
                break;
            case PlayerModel.TITANIUM:
                _tfTitanium.text = _playerModel.titanium.toString();
                break;
            case PlayerModel.GOLD:
                _tfGold.text = _playerModel.gold.toString();
                break;
            case PlayerModel.TUNGSTEN:
                _tfTungsten.text = _playerModel.tungsten.toString();
                break;
            case PlayerModel.RARE:
                _tfRare.text = _playerModel.rare.toString();
                break;
        }
    }

    /* UPDATE INFO */
    private function updateInfo(e:MouseEvent):void
    {
        if(_playerModel.actions[e.target.name] != null)
        {
            var action:Action = _playerModel.actions[e.target.name];
            setInfoFromLoc(e.target.name, !action.isAval);
            updateCostIcons(true, action.cost);
            // если действие недоступно - написать warning
        }
        else
        {
            if(!_gameModel.currentSelected) clearInfoPanel();
            if(Locale.getCaption(e.target.name) != "")
            {
                setInfoFromLoc(e.target.name);
            }
            else
            {
                if(e.target is McGroundTile)
                {
                    var underTile:GroundTile = LevelObject.getTileByCoordinates(e.target.x, e.target.y, _levelObject.groundArray);

                    if(underTile)
                    {
                        if(underTile.groundType > 0)
                        {
                            setInfoFromLoc("ground" + underTile.groundType.toString());
                        }
                    }
                }
                else
                {
                    updatedSelected();
                    updateCostIcons(false);
                }
            }
        }
    }

    /* SET INFO FROM LOCALE*/
    private function setInfoFromLoc(key:String, isWarning:Boolean=false):void
    {
        _tfCaption.text = Locale.getCaption(key);
        _tfCaption.textColor = uint(Locale.getColor(key));
        _tfDescription.text = Locale.getDesc(key);
        if(isWarning)   _tfWarning.text = Locale.getWarning(key);
        else            _tfWarning.text = "";
    }

    /* CLEAR INFO PANEL */
    private function clearInfoPanel():void
    {
        _tfCaption.text = "";
        _tfDescription.text = "";
        _tfWarning.text = "";
        updateCostIcons(false);
    }

    /* UPDATE COST ICONS */
    private function updateCostIcons(isShow:Boolean, costs:Value=null):void
    {
        if(isShow)
        {
            if(costs)
            {
                var costCounter:int = -1;
                for (var i:int = 0; i < costs.values.length; i++)
                {
                    var value:int = costs.values[i];
                    if(value > 0)
                    {
                        costCounter++;
                        _costIcons[costCounter].gotoAndStop(i+1);
                        _costIcons[costCounter].tf.text = value.toString();
                        _costIcons[costCounter].visible = true;
                    }
                }
            }
            // show icons
        }
        else
        {
            _costIcon_1.visible = false;
            _costIcon_2.visible = false;
            _costIcon_3.visible = false;
        }

    }

    /* UPDATE MOVE POINTS */
    public function updateMovePoints():void
    {
        _moveCounter.gotoAndStop(_playerModel.walkPoints+1);
    }
}
}
