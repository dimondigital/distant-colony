/**
 * Created by Sith on 05.08.14.
 */
package MVC.units
{

import MVC.ClipLabel;

import com.greensock.TweenLite;
import com.greensock.TweenMax;

import flash.display.MovieClip;
import level.GroundTile;
import level.LevelObject;

import sound.SoundManager;

import utils.Direction;

public class Drill extends AUnit
{

    private var _availableLayers:Array; // доступные для бурения слои

    /*CONSTRUCTOR*/
    public function Drill(visionRange:int, health:int, id:int, availableLayers:Array)
    {
        _availableLayers = availableLayers;
        var view:MovieClip = new McDrill();
        super(visionRange, health, view, id);
        clipLabels = new Vector.<ClipLabel>();
        clipLabels.push(new ClipLabel("stand", 1, 0.5));
        clipLabels.push(new ClipLabel("walk", 2, 0.2));
        internalView = view["intDrill"];
        playState("stand");
        _currentDirection = Direction.DOWN;
    }

    /* DRAW PATH */
    public override function drawPath(groundArray:Vector.<Vector.<GroundTile>>=null):void
    {
//        trace("Drill : draw path");
        if(_groundArray == null) _groundArray = groundArray;
        unitTile = LevelObject.getTileByCoordinates(view.x, view.y, _groundArray);
//        trace(view.x, view.y);
    }

    /* UPDATE PATH */
    public override function updatePath(underTile:GroundTile, drillSpeed:int, walkPoints:int):void
    {
        // ограничиваем путь при условии что тип тайла "небуровой".
        if(underTile.groundType  > 0)
        {
            var unitTile:GroundTile;
            // отсчёт от узла
            if(nodeTile)
            {
                unitTile = nodeTile;
            }
            // отсчёт от родительсткого тайла
            else
            {
                unitTile = super.unitTile;
            }
            tempPath = buildPath(underTile, unitTile, _groundArray, _availableLayers, drillSpeed, walkPoints);
        }
    }

    /* MOVE BY PATH */
    private var _endAnimationCallback:Function;
    private var _stepEndCallback:Function;
    private var _counter:int;
    private var _totalCount:int;
    public override function moveByPath(endAnimationCallback:Function, stepEndCallback:Function):void
    {
        playState("walk");
        SoundManager.playSound(SoundManager.DRILL_MOVE, 0.4, 0, 2);
        _endAnimationCallback = endAnimationCallback;
        _stepEndCallback = stepEndCallback;
        _counter = 0;
        _totalCount = totalTempPath.length;
        stepMove();
    }

    /* STEP MOVE */
    private function stepMove():void
    {
        var rotationAngle:Number;
        rotationAngle = checkRotation();
        if(rotationAngle != 0)
        {
            TweenMax.to(internalView, 0.5, {rotation:internalView.rotation+rotationAngle, onComplete:updateCurrentRotation});

        }
        else
        {
            rotationAngle = 0;
            move();
        }

        function updateCurrentRotation():void
        {
            rotationAngle = 0;
            move();
        }
    }

    /* MOVE */
    private function move():void
    {
        TweenMax.to(view, 0.3, {x:totalTempPath[_counter].view.x, y:totalTempPath[_counter].view.y, onComplete:checkForEndAnimation});
    }

    /* CHECK FOR END ANIMATION */
    private function checkForEndAnimation():void
    {
        _stepEndCallback(totalTempPath[_counter]);
        SoundManager.playSound(SoundManager.DIG_GROUND, 0.4);
        _counter++;
        if(_counter <= _totalCount-1)
        {
            stepMove();
        }
        else
        {
            playState("stand");
            SoundManager.stopSound(SoundManager.DRILL_MOVE);
            _endAnimationCallback(this);
        }
    }

    /* CHECK ROTATION */
    private function checkRotation():int
    {
        var needRotation:int;
        var needDir:int;
        var curTile:GroundTile = LevelObject.getTileByCoordinates(view.x, view.y, _groundArray);
        var nextTile:GroundTile = totalTempPath[_counter];
        // по-горизонтали
        if(curTile.hIndex ==  nextTile.hIndex)
        {
            // влево
            if(curTile.wIndex > nextTile.wIndex) needDir = Direction.LEFT;
            // вправо
            if(curTile.wIndex < nextTile.wIndex) needDir = Direction.RIGHT;
        }
        // по-вертикали
        else if(curTile.wIndex ==  nextTile.wIndex)
        {
            // вверх
            if(curTile.hIndex > nextTile.hIndex) needDir = Direction.UP;
            // вниз
            if(curTile.hIndex < nextTile.hIndex) needDir = Direction.DOWN;
        }

        if(_currentDirection == needDir) return 0;
        else
        {
            if(_currentDirection == Direction.DOWN)
            {
                if(needDir == Direction.LEFT) { needRotation = 90; _currentDirection = Direction.LEFT;}
                else if(needDir == Direction.UP) { needRotation = -180;  _currentDirection = Direction.UP;}
                else if(needDir == Direction.RIGHT) { needRotation = -90;  _currentDirection = Direction.RIGHT;}
            }
            else if(_currentDirection == Direction.LEFT)
            {
                if(needDir == Direction.UP)  {needRotation = 90;  _currentDirection = Direction.UP;}
                else if(needDir == Direction.RIGHT)  {needRotation = -180; _currentDirection = Direction.RIGHT;}
                else if(needDir == Direction.DOWN)  {needRotation = -90; _currentDirection = Direction.DOWN;}
            }
            else if(_currentDirection == Direction.UP)
            {
                if(needDir == Direction.RIGHT)  {needRotation = 90;  _currentDirection = Direction.RIGHT;}
                else if(needDir == Direction.DOWN) {needRotation = -180; _currentDirection = Direction.DOWN;}
                else if(needDir == Direction.LEFT)  {needRotation = -90; _currentDirection = Direction.LEFT;}
            }
            else if(_currentDirection == Direction.RIGHT)
            {
                if(needDir == Direction.DOWN)  {needRotation = 90; _currentDirection = Direction.DOWN;}
                else if(needDir == Direction.LEFT)  {needRotation = -180; _currentDirection = Direction.LEFT;}
                else if(needDir == Direction.UP)  {needRotation = -90;  _currentDirection = Direction.UP;}
            }
            /*var directions:Array = [1, 2, 3, 4];
            var temp:Array = directions.splice(directions.indexOf(_currentDirection), directions.length-(_currentDirection-1));
            temp = temp.concat(directions);
            trace("directions : " + temp);
            var counter:int = 1;
            var isCircle:Boolean = true;
            for (var i:int = 0; i < temp.length; i++)
            {
                if(isCircle)
                {
                    var dir:int = temp[i];
                    if(i != _currentDirection) counter++;
                    else isCircle = false;
                }
            }
            if(counter == 1) needRotation = 90;
            else if(counter == 2) needRotation = -180;
            else if(counter == 3) needRotation = -90;*/
        }
        trace("needRotation : " + needRotation);
        return needRotation;
    }




}
}
