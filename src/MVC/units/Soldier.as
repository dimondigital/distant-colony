/**
 * Created by Sith on 09.08.14.
 */
package MVC.units
{
import MVC.ClipLabel;
import MVC.IAttackable;

import com.greensock.TweenMax;

import flash.display.MovieClip;
import flash.display.Sprite;

import level.GroundTile;
import level.LevelObject;

import sound.SoundManager;

import utils.Direction;

public class Soldier extends AHorizontalUnit implements IAttackable
{
    private var _attackDamage:int;
    private var _isCanAttack:Boolean;

    /*CONSTRUCTOR*/
    public function Soldier(visionRange:int, health:int, id:int, attackDamage:int, view:MovieClip)
    {
        _attackDamage = attackDamage;
        super(visionRange, health, id, view);
        clipLabels = new Vector.<ClipLabel>();
        clipLabels.push(new ClipLabel("stand", 1, 0.5));
        clipLabels.push(new ClipLabel("walk", 7, 0.6));
        internalView = view["intSoldier"];
        playState("stand");
        _currentDirection = Direction.RIGHT;
    }

    /* ATTACK */
    public function attack():void
    {

    }

    /* DRAW PATH */
    public override function drawPath(groundArray:Vector.<Vector.<GroundTile>>=null):void
    {
//        trace("Soldier : draw path");
        if(_groundArray == null) _groundArray = groundArray;
        if(nodeTile)
        {
            unitTile = nodeTile;
        }
        // отсчёт от родительсткого тайла
        else
        {
            unitTile = super.unitTile;
        }
        // у солдата unitTile располагается на один тайл ниже его координат
        unitTile = LevelObject.getTileByCoordinates(view.x, view.y+(DistantColony.TILE_SIZE*2), _groundArray);
    }

    /* UPDATE PATH */
    public override function updatePath(underTile:GroundTile, drillSpeed:int, walkPoints:int):void
    {
//        trace("Soldier : update path");
        // ограничиваем путь при условии что тип тайла "небуровой".
        if(underTile.groundType == 0)
        {
            var unitTile:GroundTile;
            // отсчёт от узла
            unitTile = super.unitTile;

            tempPath = buildPath(underTile, unitTile, _groundArray, [0], 0, walkPoints, true);
        }
    }

    /* MOVE BY PATH */
    private var _endAnimationCallback:Function;
    private var _stepEndCallback:Function;
    private var _counter:int;
    private var _totalCount:int;
    public override function moveByPath(endAnimationCallback:Function, stepEndCallback:Function):void
    {
        updateDirection();
        playState("walk");
        SoundManager.playSound(SoundManager.ROBOT_WALK, 0.4, 0, 3);
        _endAnimationCallback = endAnimationCallback;
        _stepEndCallback = stepEndCallback;
        _counter = 0;
        _totalCount = totalTempPath.length;

        TweenMax.to(view, 0.5 * totalTempPath.length, {x:totalTempPath[totalTempPath.length-1].view.x});
        stepMove();
    }

    /* STEP MOVE */
    private function stepMove():void
    {
        move();
    }

    /* MOVE */
    private function move():void
    {
        TweenMax.to(view, 0.5, {onComplete:checkForEndAnimation});
    }

    /* CHECK FOR END ANIMATION */
    private function checkForEndAnimation():void
    {
        _stepEndCallback(totalTempPath[_counter]);
//        SoundManager.playSound(SoundManager.DIG_GROUND, 0.4);
        _counter++;
        if(_counter <= _totalCount-1)
        {
            stepMove();
        }
        else
        {
            playState("stand");
            SoundManager.stopSound(SoundManager.ROBOT_WALK);
//            SoundManager.stopSound(SoundManager.ROBOT_SOLDIER_MOVE);
            _endAnimationCallback(this);
        }
    }

    public function get attackDamage():int {return _attackDamage;}

    public function get isCanAttack():Boolean {
        return _isCanAttack;
    }

    public function set isCanAttack(value:Boolean):void {
        _isCanAttack = value;
    }
}
}
