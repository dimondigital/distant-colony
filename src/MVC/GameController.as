/**
 * Created by Sith on 04.08.14.
 */
package MVC
{
import MVC.AContent;
import MVC.players.Bot;
import MVC.players.IPlayer;
import MVC.players.Player;
import MVC.players.PlayerModel;
import MVC.units.IPath;
import MVC.units.IPath;
import MVC.units.IPath;
import MVC.units.Soldier;

import events.SelectEvent;

import flash.display.Sprite;
import flash.display.Stage;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.ui.Mouse;

import gui.cursor.CustomCursor;

import level.GroundTile;
import level.LevelBuilder;
import level.LevelObject;
import level.Value;
import level.Value;

import sound.SoundManager;

public class GameController extends Sprite implements IController
{
    private var _gameModel:GameModel;
    private var _gameView:GameView;

    private var _levelBuilder:LevelBuilder;
    private var _levelObject:LevelObject;

    private var _players:Vector.<IPlayer>;
    private var _currentMoved:IPlayer;

    /*CONSTRUCTOR*/
    public function GameController(stage:Stage)
    {
        _gameView = new GameView(stage);
        // init players
        _players = new Vector.<IPlayer>();
        _players.push(new Player(endMove, new PlayerModel(GameModel.PLAYER_ID, _gameView), _gameView, _levelObject));
        _players.push(new Bot(endMove, new PlayerModel(GameModel.BOT_ID, _gameView)));

        _gameModel = new GameModel(_gameView, _players);
        _gameView.initModel(_gameModel);

        // init game model special for player
        _players[0].initGameModel(_gameModel);
    }

    /* INIT */
    public function init():void
    {
        trace("GAME CONTROLLER : init");
        for (var i:int = 0; i < _players.length; i++)
        {
            var player:IPlayer = _players[i];
            player.initStartContent();
            // init start content coordinates
            var hqCoordinates:Point; // координаты штаба
            var drillCoordinates:Point; // координаты буровой машины
            if(i == 0)
            {
                hqCoordinates = LevelObject.getTileCoordinates(1, 6);
                drillCoordinates = LevelObject.getTileCoordinates(1, 7);
            }
            else if(i == 1)
            {
                hqCoordinates = LevelObject.getTileCoordinates(27, 6);
                drillCoordinates = LevelObject.getTileCoordinates(27, 7);
            }
            player.model.contents[0].view.x  = hqCoordinates.x ;
            player.model.contents[0].view.y = hqCoordinates.y ;
            player.model.contents[1].view.x = drillCoordinates.x;
            player.model.contents[1].view.y = drillCoordinates.y;
        }

       _gameView.addEventListener(SelectEvent.SELECT, select, true);
        _gameView.addEventListener(MouseEvent.MOUSE_MOVE, updatePath);

        _levelBuilder = new LevelBuilder(30, 31, drawView, new LevelObject());
        _levelBuilder.startBuild();
    }

    /* DRAW VIEW */
    public function drawView(levelObj:LevelObject, levelSpr:Sprite):void
    {
        trace("GAME CONTROLLER : draw view");
        _levelObject = levelObj;
        _gameView.initLevelSprite(levelSpr);
        _gameView.initPlayers(_players);
        _gameView.initLevelTiles(_levelObject.groundArray);
        _gameModel.players[0].initLevelObject(_levelObject);
        _gameView.updateValues();
        _gameView.updateDark();
        addChild(_gameView);

        startGame();
    }

    /* START GAME */
    private function startGame():void
    {
        trace("GAME CONTROLLER : start game");
//        SoundManager.playSound(SoundManager.MUSIC_1, 0.3, 0, 5);
        _currentMoved = _players[0];
        _currentMoved.activateInterface();
        _currentMoved.move();
    }

    /* SELECT */
    private var _select:AContent;
    private function select(e:SelectEvent):void
    {
        _select = e.selectedObject;
        if(_select.id == GameModel.PLAYER_ID)
        {
            var currentSelected:AContent = _gameModel.currentSelected;

            if(_select != currentSelected)
            {
//                SoundManager.playSound(SoundManager.SELECT, 0.5);
                if(_select is Soldier)
                {
                    var random:int = Math.ceil(Math.random() * 3);
                    var soundName:String = "robotTalk" + random;
                    SoundManager.playSound(soundName, 0.4);
                }
                _gameView.selectorLayer.addEventListener(MouseEvent.CLICK, onClickIfSelected);
                _gameView.selectorLayer.addEventListener(MouseEvent.CLICK, attack);
                _gameView.updateSelected(_select as AContent);
                _gameModel.currentSelected = e.selectedObject;
                if(_select is IPath)
                {
                    IPath(_select).drawPath(_levelObject.groundArray);
                }
            }
            else if(_select == currentSelected)
            {
                _gameModel.currentSelected = null;
                _gameView.selectorLayer.removeEventListener(MouseEvent.CLICK, onClickIfSelected);
                _gameView.selectorLayer.removeEventListener(MouseEvent.CLICK, attack);
                if(_select is IPath)
                {
                    _select.dispatchEvent(new SelectEvent(_select, SelectEvent.DESELECT, true));
                    IPath(_select).nodeTile = null;
                    _gameView.clearTempPath(IPath(currentSelected).totalTempPath);
                    IPath(currentSelected).totalTempPath = null;
                    _gameView.clearWrongPath(IPath(currentSelected).wrongPath);
//                IPath(currentSelected).wrongPath = null;
                }
                _gameView.deselect();
                _gameModel.currentSelected = null;
            }

        }
    }

    private function deselect():void
    {

    }


    /* UPDATE PATH */
    private function updatePath(e:MouseEvent=null):void
    {
        var currentSelected:AContent = _gameModel.currentSelected;
        var underTile:GroundTile = _levelObject.getTileByCoordinates(e.target.x, e.target.y);
        var isCanAttack:Boolean;
//        trace("underTile : " + underTile.groundType);
//        var underTile:GroundTile = _levelObject.getTileByCoordinates(int(stage.mouseX/DistantColony.SCALE_FACTOR), int(stage.mouseY/DistantColony.SCALE_FACTOR));
        if(currentSelected != null && underTile != null)
        {
            // сначала проверим - может ли выбранный атаковать при условии, что под тайлом вражеский контент

            if(currentSelected is IAttackable)
            {
                var enemyUnderTile:AContent = checkEnemyUnderTile(underTile);
                _gameView.updateAttackCursor(enemyUnderTile, underTile);
                _gameModel.attackedContent = enemyUnderTile;
                if(enemyUnderTile && !isCanAttack)
                {
                    isCanAttack = true;
                    IAttackable(currentSelected).isCanAttack = true;
                }
                else
                {
                    isCanAttack = false;
                    IAttackable(currentSelected).isCanAttack = false;
                }
            }
            else
            {
                isCanAttack = false;
            }

            // если юнит способен передвигаться и никого не собирается никого атаковать
            if(currentSelected is IPath && !isCanAttack)
            {
                IPath(currentSelected).updatePath(underTile, _players[0].model.drillingSpeed, _players[0].model.walkPoints);
                var curNode:GroundTile;
                if(IPath(currentSelected).nodeTile) curNode = IPath(currentSelected).nodeTile;
                else                                curNode = IPath(currentSelected).unitTile;

                if(underTile != curNode)
                {
                    if(IPath(currentSelected).totalTempPath == null)
                    {
                        _gameView.drawTempPath(IPath(currentSelected).tempPath);
                    }
                    else
                    {
                        var tPath:Vector.<GroundTile> = IPath(currentSelected).tempPath.concat(IPath(currentSelected).totalTempPath);
                        _gameView.drawTempPath(tPath);

                    }

                    if(IPath(currentSelected).wrongPath != null)
                    {
                        if(IPath(currentSelected).wrongPath.length > 0)
                        {
                            if(underTile.selectorType == GroundTile.SELECT_TEMP || underTile.selectorType == GroundTile.SELECT_NONE)
                            {
//                                Mouse.show();
                                _gameView.clearWrongPath(IPath(currentSelected).wrongPath);
                                IPath(currentSelected).wrongPath = null;
                            }
                            else
                            {
//                                Mouse.hide();
                                _gameView.drawWrongPath(IPath(currentSelected).wrongPath)
                            }
                        }

                    }
                }
                else
                {
//                        if(underTile.selectorType == GroundTile.SELECT_TEMP || underTile.selectorType == GroundTile.SELECT_WRONG)
//                        {
//                            Mouse.hide();
//                        }
//                        else   Mouse.show();

                    _gameView.clearTempPath(IPath(currentSelected).tempPath);
                     if(IPath(currentSelected).wrongPath.length > 0)
                     {
                         _gameView.clearWrongPath(IPath(currentSelected).wrongPath);
                         IPath(currentSelected).wrongPath = null;
                     }
//
                    _gameView.clearTempPath(IPath(currentSelected).totalTempPath);
//                    IPath(currentSelected).totalTempPath = null;
                }
            }
        }
    }

    /* CHECK ENEMY UNDER TILE */
    // проверка - есть ли под координатами вражеский контент
    private function checkEnemyUnderTile(underTile:GroundTile):AContent
    {
        for each(var cont:AContent in _players[1].model.contents)
        {
            if(underTile.view.x >= cont.view.x && underTile.view.x <= cont.view.x + cont.view.width)
            {
                if(underTile.view.y >= cont.view.y && underTile.view.y <= cont.view.y + cont.view.height)
                {
                    return cont;
                }
            }
        }
        return null;
    }

    /* ATTACK */
    private function attack(e:MouseEvent):void
    {
        if(_select is IAttackable)
        {
            if(IAttackable(_select).isCanAttack)
            {
                if(_gameModel.attackedContent.health > 0)
                {
                    _gameModel.attackedContent.health -= IAttackable(_select).attackDamage;
                    _gameModel.players[0].model.walkPoints --;
                    _gameView.attack(IAttackable(_select).attackDamage, _gameModel.attackedContent);
                }
                else
                {
                    _gameView.endGame();
                }
            }
        }
    }

    /* ON CLICK IF SELECTED */
    private function onClickIfSelected(e:MouseEvent):void
    {
        var underClickTile:GroundTile = _levelObject.getTileByCoordinates(e.localX, e.localY);
        var lastIndex:int =  IPath(_select).tempPath.length-1;
        if(lastIndex > -1)
        {
            var tempPathLast:GroundTile = IPath(_select).tempPath[lastIndex];
//            trace(" w : " + underClickTile.wIndex);
//            trace(" h : " + underClickTile.hIndex);
            // если тайл клика является последним во временном пути - задаём новый узел в пути
            if(underClickTile == tempPathLast )
            {
                // делаем юнита не выбираемым, пока он не завершит свой путь
                _select.isSelectable = false;
                _gameModel.currentSelected = null;
                _gameView.selectorLayer.removeEventListener(MouseEvent.CLICK, onClickIfSelected);
                // путь юнита подтвердили
                IPath(_select).nodeTile = null;
                IPath(_select).totalTempPath = IPath(_select).totalTempPath.concat(IPath(_select).tempPath);


                _gameView.deselect();

                if(IPath(_select).totalTempPath.length > 0) IPath(_select).moveByPath(endAnimation, stepEnd);
                else endAnimation(_select);
            }

        }
    }

    /* STEP END */
    // коллбек шага юнита
    public function stepEnd(diggedGround:GroundTile):void
    {
        diggedGround.dig();
        diggedGround.setSelectorType(GroundTile.SELECT_NONE, _gameView.selectorLayer);
        // отнимаем очки хода
        _players[0].model.walkPoints -= diggedGround.walkPoints;
        // добавляем ресурсы в модель игрока
        if(diggedGround.value) Value.addMetal(diggedGround.value, _players[0].model);
        // обновляем поле зрения юнита
        _gameView.updateDark();
    }



    /* END ANIMATION */
    public function endAnimation(selectObj:AContent):void
    {
        IPath(selectObj).tempPath = null;
        IPath(selectObj).totalTempPath = null;
        IPath(selectObj).wrongPath = null;
        selectObj.isSelectable = true;
        selectObj.view.dispatchEvent(new SelectEvent(selectObj, SelectEvent.SELECT, true));
//        _gameModel.currentSelected = selectObj;
         _gameView.updateDark();
    }






    /* END MOVE */
    private function endMove():void
    {
        // отключаем взаимодействие с интефейсом у игрока, который закончил ход
        _currentMoved.deactivateInterface();
        if(_currentMoved == _players[0])
        {

            trace("GAME CONTROLLER : PLAYER - end move. BOT - start move.");
            _currentMoved = _players[1];
        }
        else
        {
            trace("GAME CONTROLLER : BOT - end move. PLAYER - start move.");
            _currentMoved = _players[0];
        }

        _currentMoved.activateInterface();
        _currentMoved.move();
    }


    public function get players():Vector.<IPlayer> {
        return _players;
    }
}
}
