/**
 * Created by Sith on 04.08.14.
 */
package MVC
{
import MVC.buildings.ABuilding;
import MVC.players.IPlayer;
import MVC.units.AUnit;

import camera.AMovableController;
import camera.MapMover;
import camera.MovableModel;
import camera.MoveLimiter;

import com.greensock.TweenMax;
import com.greensock.easing.Expo;

import cv.Orion;
import cv.orion.filters.ColorFilter;
import cv.orion.filters.ScaleFilter;
import cv.orion.filters.WanderFilter;
import cv.orion.output.BurstOutput;

import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.filters.GlowFilter;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.ui.Mouse;

import inputController.KeyboardController;

import level.GroundTile;

import sound.SoundManager;

public class GameView extends Sprite implements IGameView
{
    private var _stage:Stage;
    private var _gameModel:GameModel;

    private var _camera:MapMover;
    private var _cameraTarget:AMovableController;
    private var _keyboardController:KeyboardController;
    private var _cameraLimiter:MoveLimiter;

    private var _gameScreen:Sprite;
    // screenLayers
    private var _backGroundLayer:Sprite;
    private var _groundLayer:Sprite;
    private var _valueLayer:Sprite;
    private var _buildLingLayer:Sprite;
    private var _unitLayer:Sprite;
    private var _selectorLayer:Sprite;
    private var _particleLayer:Sprite;
    private var _darkLayer:Sprite;

    private var _players:Vector.<IPlayer>;

    private var _tilesArray:Vector.<Vector.<GroundTile>>;



    /*CONSTRUCTOR*/
    public function GameView(stage:Stage)
    {
        _stage = stage;
        _gameScreen = new Sprite();
        addChild(_gameScreen);

        _backGroundLayer = new Sprite();
        _groundLayer = new Sprite();
        _valueLayer = new Sprite();
        _buildLingLayer = new Sprite();
        _unitLayer = new Sprite();
        _selectorLayer = new Sprite();
        _particleLayer = new Sprite();
        _darkLayer = new Sprite();

        _gameScreen.addChildAt(_backGroundLayer, 0);
        _gameScreen.addChildAt(_groundLayer, 1);
        _gameScreen.addChildAt(_valueLayer, 2);
        _gameScreen.addChildAt(_buildLingLayer, 3);
        _gameScreen.addChildAt(_unitLayer, 4);
        _gameScreen.addChildAt(_selectorLayer, 5);
        _gameScreen.addChildAt(_particleLayer, 6);
        _gameScreen.addChildAt(_darkLayer, 7);

       initSelector();
    }

    /* INIT MODEL */
    public function initModel(gameModel:GameModel):void
    {
        _gameModel = gameModel;
    }


    /* INIT SELECTOR */
    private var _selectUpLeft:McSelector;
    private var _selectUpRight:McSelector;
    private var _selectDownLeft:McSelector;
    private var _selectDownRight:McSelector;
    private function initSelector():void
    {
        _selectUpLeft = new McSelector();
        _selectUpRight = new McSelector();
        _selectUpRight.rotation = 90;
        _selectDownLeft = new McSelector();
        _selectDownLeft.rotation = -90;
        _selectDownRight = new McSelector();
        _selectDownRight.rotation = -180;
    }

    /* INIT LEVEL SPRITE */
    public function initLevelSprite(spr:Sprite):void
    {
        _groundLayer.addChild(spr);

        // init camera target
        var targetModel:MovableModel = new MovableModel();
        _cameraTarget = new AMovableController(new McCameraTarget, targetModel);
        _cameraTarget.view.x = 128;
        _cameraTarget.view.y = 128;
        _cameraTarget.view.alpha = 0;
        _gameScreen.addChild(_cameraTarget.view);
        // init cameraTarget move limiter
        _cameraLimiter = new MoveLimiter(_cameraTarget.view, targetModel, 128, 128, (spr.width-256), (spr.height-256));
        // init keyboard controller
        _keyboardController = new KeyboardController(targetModel, _stage);
        // init camera
        var fixPoint:Point = new Point(_cameraTarget.view.x, _cameraTarget.view.y);
        _camera = new MapMover(_stage, _cameraTarget.view, _gameScreen, fixPoint, 1);
        // init main loop
        addEventListener(Event.ENTER_FRAME, mainLoop);
    }

    /* INIT PLAYERS */
    public function initPlayers(players:Vector.<IPlayer>):void
    {
        _players = players;
        // draw player contents
        for (var i:int = 0; i < _players.length; i++)
        {
            var player:IPlayer = _players[i];
            for (var j:int = 0; j < player.model.contents.length; j++)
            {
                var content:AContent =  player.model.contents[j];
                if(content is ABuilding) _buildLingLayer.addChild(content.view);
                else if (content is AUnit) _unitLayer.addChild(content.view);
            }
        }
    }

    /* INIT LEVEL TILES */
    public function initLevelTiles(tilesArray:Vector.<Vector.<GroundTile>>):void
    {
        _tilesArray = tilesArray;
    }

    /* UPDATE VALUES */
    public function updateValues():void
    {
        for (var w:int = 0; w < _tilesArray.length; w++)
        {
            for (var h:int = 0; h < _tilesArray[w].length; h++)
            {
                var tile:GroundTile = _tilesArray[w][h];
                tile.valueLayer = _valueLayer;
            }
        }
    }


    /* UPDATE DARK */
    public function updateDark():void
    {

        for (var w:int = 0; w < _tilesArray.length; w++)
        {
            for (var h:int = 0; h < _tilesArray[w].length; h++)
            {
                var tile:GroundTile = _tilesArray[w][h];
                tile.inVisionRange = false;
                if(tile.darkLayer == null) tile.darkLayer = _darkLayer;
                if(tile.particleLayer == null) tile.particleLayer = _particleLayer;
                if(h < 7) tile.isExplored = true;

                for (var i:int = 0; i < _players[0].model.contents.length; i++)
                {
                    // освещаем только те тайлы, которые попадают в диапазон обзора игрока, но не бота.
                    var content:AContent = _players[0].model.contents[i];
                    // проверяем попадает ли тайл в диапазон обзора контента
                    var distanceX:Number = Math.abs(content.view.x - tile.view.x);
                    var distanceY:Number = Math.abs(content.view.y - tile.view.y);
                    var range:Number = content.visionRange * (DistantColony.TILE_SIZE);
                    if(distanceX < range && distanceY < range)
                    {
                        tile.inVisionRange = true;
                        tile.isExplored = true;
                    }
                }
            }
        }

        for (var o:int = 0; o < _tilesArray.length; o++)
        {
            for (var p:int = 0; p < _tilesArray[o].length; p++)
            {
                var tile2:GroundTile = _tilesArray[o][p];
                if(tile2.inVisionRange)
                {
                    tile2.visibleState = GroundTile.VISIBLE;
                }

                else
                {
                    if(tile2.isExplored || h < 5) tile2.visibleState = GroundTile.HALF_DARKED;
                    else                tile2.visibleState = GroundTile.DARKED;
                }
            }
        }

    }

    /* UPDATE SELECTED */
    public function updateSelected(selected:AContent):void
    {
        // если выбранный юнит является юнитом игрока
        if(selected.id == GameModel.PLAYER_ID)
        {
            _selectUpLeft.visible = true;
            _selectUpLeft.x = selected.view.x;
            _selectUpLeft.y = selected.view.y;
            _selectorLayer.addChild(_selectUpLeft);

            _selectUpRight.visible = true;
            _selectUpRight.x = selected.view.x + selected.view.width;
            _selectUpRight.y = selected.view.y;
            _selectorLayer.addChild(_selectUpRight);

            _selectDownLeft.visible = true;
            _selectDownLeft.x = selected.view.x;
            _selectDownLeft.y = selected.view.y + selected.view.height;
            _selectorLayer.addChild(_selectDownLeft);

            _selectDownRight.visible = true;
            _selectDownRight.x = selected.view.x + selected.view.width;
            _selectDownRight.y = selected.view.y + selected.view.height;
            _selectorLayer.addChild(_selectDownRight);
        }
        else
        {
            // возможные действия юнита против вражеского юнита
        }
    }

    /* DESELECT */
    public function deselect():void
    {
        _selectUpLeft.visible = false;
        _selectUpRight.visible = false;
        _selectDownLeft.visible = false;
        _selectDownRight.visible = false;
    }

    /* DRAW TEMP PATH */
    private var _tempPath:Vector.<GroundTile>;
    public function drawTempPath(tempPath:Vector.<GroundTile>):void
    {
        // если до этого уже отрисовывался tempPath - очищаем его
        if(_tempPath) clearTempPath(_tempPath);
        for each(var tile:GroundTile in tempPath)
        {
            tile.setSelectorType(GroundTile.SELECT_TEMP, _selectorLayer);
        }
        _tempPath = tempPath;
    }

    /* DRAW GREEN SELECTOR */
    public function drawGreenSelector(tile:GroundTile):void
    {
        tile.setSelectorType(GroundTile.SELECT_GREEN, _selectorLayer);
    }

    /* DRAW WRONG PATH */
    private var _wrongPath:Vector.<GroundTile>;
    public function drawWrongPath(wrongPath:Vector.<GroundTile>):void
    {
        // если до этого уже отрисовывался tempPath - очищаем его
        if(_wrongPath) clearWrongPath(_wrongPath);
        for each(var tile:GroundTile in wrongPath)
        {
            tile.setSelectorType(GroundTile.SELECT_WRONG, _selectorLayer);
        }
        _wrongPath = wrongPath;
    }

    /* CLEAR TEMP PATH */
    public function clearTempPath(tempPath:Vector.<GroundTile>):void
    {

        if(tempPath)
        {
            for each(var tile:GroundTile in tempPath)
            {
                tile.setSelectorType(GroundTile.SELECT_NONE, _selectorLayer);
            }
        }
    }

    /* CLEAR TEMP PATH */
    public function clearWrongPath(wrongPath:Vector.<GroundTile>):void
    {
        if(wrongPath)
        {
            for each(var tile:GroundTile in wrongPath)
            {
                tile.setSelectorType(GroundTile.SELECT_NONE, _selectorLayer);
            }
        }

    }

    /* UPDATE ATTACK CURSOR */
    private var _attackCursor:McAttackCursor;
    public function updateAttackCursor(enemy:AContent, underTile:GroundTile):void
    {

        if(enemy)
        {
            Mouse.hide();
            if(_attackCursor == null) _attackCursor = new McAttackCursor();
            _attackCursor.x = enemy.view.x;
            _attackCursor.y = enemy.view.y;
            underTile.setSelectorType(GroundTile.SELECT_NONE, _selectorLayer);
            _selectorLayer.addChild(_attackCursor);
        }
        else
        {
            Mouse.show();
            if(_attackCursor) _selectorLayer.removeChild(_attackCursor);
            _attackCursor = null;
        }
    }

    /* ATTACK */
    private var _glowFilter:GlowFilter = new GlowFilter(0xFFF201, 0.6, 6, 6);
    public function attack(attackDamage:int, attackedContent:AContent):void
    {
        // animate flying textfield
        var flyingTf:McFlyingTf = new McFlyingTf();
        flyingTf.tf.text = "- " + attackDamage;
        flyingTf.x = attackedContent.view.x + attackedContent.width/2;
        flyingTf.y = attackedContent.view.y;
        _buildLingLayer.addChild(flyingTf);
        TweenMax.to(flyingTf, 0.5, {y:flyingTf.y - 20, alpha:0, onComplete:destroyTf});
        function destroyTf():void
        {
            _buildLingLayer.removeChild(flyingTf);
            flyingTf = null;
        }

        // animate explosive
        shakeTween(_gameScreen, 1, 500);
        SoundManager.playSound(SoundManager.EXPLOSIVE);
        var explosive:McExplosive_16x16 = new McExplosive_16x16();
        explosive.rotation = Math.random() * 360;
        explosive.filters = [_glowFilter];
        explosive.x = attackedContent.view.x + attackedContent.width/2;
        explosive.y = attackedContent.view.y + attackedContent.height/2;
        explosive.addEventListener(Event.EXIT_FRAME, onExitFrame);
        _buildLingLayer.addChild(explosive);
        function onExitFrame(e:Event):void
        {
            if(explosive.currentFrame == explosive.totalFrames)
            {
                explosive.removeEventListener(Event.EXIT_FRAME, onExitFrame);
                _buildLingLayer.removeChild(explosive);
                explosive = null;
            }
        }
    }

    /* EXPLORE */
    public function explore():void
    {
        SoundManager.playSound(SoundManager.EXPLORE, 0.4);
    }

    /* END GAME */
    public function endGame():void
    {
        var endGameScreen:McEndGameScreen = new McEndGameScreen();
        endGameScreen.x = 0;
        endGameScreen.x = 0;
        addChild(endGameScreen);
    }

    /* SHAKE TWEEN */
    private function shakeTween(item:Sprite, repeatCount:int, duration:Number, randomRange:int=0):void
    {
        TweenMax.to(item,duration,{repeat:repeatCount-1, y:item.y+(1+Math.random()*randomRange), x:item.x+(1+Math.random()*randomRange), delay:duration, ease:Expo.easeInOut});
        TweenMax.to(item,duration,{y:item.y, x:item.x, delay:(repeatCount+1) * .1, ease:Expo.easeInOut});
    }

    /* BUILD */
    private var _buildParticleSettings:Object = {lifeSpan:2000, mass:-5, alphaMin:1, alphaMax:0, scaleMax:0.7, scaleMin:0.1};
    public function build(x:Number, y:Number, width:Number, height:Number):void
    {
        SoundManager.playSound(SoundManager.BUILD, 0.4);


        var particleEffectFilters:Object = [new ScaleFilter(0.95), new WanderFilter(0.5, 0.5), new ColorFilter(0xD6D6D6)];
        var o:Orion = new Orion(ImgDust, new BurstOutput(50, false), {settings:_buildParticleSettings, effectFilters:particleEffectFilters, useCacheAsBitmap:true}, true);
        o.canvas = new Rectangle(0, 0, 16, 16);
        o.x = x;
        o.y = (y + height) - DistantColony.TILE_SIZE ;
        o.width = width;
        o.height = 16;
        _particleLayer.addChild(o);
    }

    /* DIG */
    public function dig(totalTempPath:Vector.<GroundTile>):void
    {
        for each(var tile:GroundTile in totalTempPath)
        {
            tile.dig();
            tile.setSelectorType(GroundTile.SELECT_NONE, _selectorLayer);
        }
    }



    /* MAIN LOOP */
    private function mainLoop(e:Event):void
    {
        _cameraLimiter.limitMove();
        _cameraTarget.moving();
        _camera.cameraLoop();
    }

    public function get groundLayer():Sprite {
        return _groundLayer;
    }

    public function get selectorLayer():Sprite {
        return _selectorLayer;
    }

    public function get buildLingLayer():Sprite {
        return _buildLingLayer;
    }

    public function get unitLayer():Sprite {
        return _unitLayer;
    }
}
}
