/**
 * Created by Sith on 05.08.14.
 */
package MVC.units
{
import MVC.AContent;

import flash.display.MovieClip;

import level.GroundTile;

/* АСБСТРАКТНЫЙ ЮНИТ */
public class AUnit extends AContent implements IPath
{
    protected var _path:Vector.<GroundTile>;
    private var _tempPath:Vector.<GroundTile>; // рабочий в данный момент временный путь
    private var _totalTempPath:Vector.<GroundTile>; // собранный временный путь
    private var _wrongPath:Vector.<GroundTile>;
    protected var _groundArray:Vector.<Vector.<GroundTile>>;
    private var _unitTile:GroundTile;
    private var _nodeTile:GroundTile;

    protected var _currentDirection:int;

    /*CONSTRUCTOR*/
    public function AUnit(visionRange:int, health:int, view:MovieClip, id:int)
    {
        super(visionRange, health, view, id);
    }

    /* DRAW PATH */
    public function drawPath(groundArray:Vector.<Vector.<GroundTile>>=null):void
    {

    }

    /* UPDATE PATH */
    public function updatePath(underTile:GroundTile, drillSpeed:int, walkPoints:int):void
    {
//        trace("AUnit : update path");
    }

    /* MOVE BY PATH */
    public function moveByPath(endAnimationCallback:Function, stepEndCallback:Function):void
    {
//        trace("AUnit : move by path");
    }

    /* BUILD PATH */
    private var _totalWalkPoints:int;
    public function buildPath(underTile:GroundTile, unitTile:GroundTile, groundArray:Vector.<Vector.<GroundTile>>, availableLayers:Array, drillSpeed:int, walkPoints:int, isHorisonralUnit:Boolean=false):Vector.<GroundTile>
    {
        var path:Vector.<GroundTile> = new Vector.<GroundTile>();
        var wDist:int;
        var hDist:int;
        var isAval:Boolean
        var prevIsAval:Boolean;
        var curTile:GroundTile;
        _totalWalkPoints = walkPoints;
        if(underTile.hIndex == unitTile.hIndex)
        {
            wDist = Math.abs(unitTile.wIndex - underTile.wIndex);
//            trace("wDist : " + wDist);
            // если путь идёт влево
            /* ВЛЕВО */
            if(unitTile.wIndex > underTile.wIndex)
            {
                for (var l:int = unitTile.wIndex-1; l >= underTile.wIndex; l--)
                {
                    // если есть ограничения
                    if(availableLayers != null)
                    {
                        curTile = groundArray[l][unitTile.hIndex];
                        isAval = false;
                        for each(var layer1:int in availableLayers)
                        {
                            if(isAval == false) isAval = (curTile.groundType == layer1);
                        }

                        if (isAval && (calculateNeedWalk(drillSpeed, curTile)))
                        {
//                            if(l == unitTile.wIndex-1)   path.push(groundArray[l][unitTile.hIndex]);
//                            else if (wrongPath.length < 1)   path.push(groundArray[l][unitTile.hIndex]);
                            if(wrongPath.length < 1) path.push(curTile);
                        }
                        else
                        {
                            if(wrongPath.indexOf(curTile) == -1) wrongPath.push(curTile);
                        }

                        // сохраняем как предыдущий результат
                        if(l != unitTile.wIndex-1)
                        {
                            prevIsAval = isAval;
                        }
                    }
                }
            }
            // если путь идёт вправо
            /* ВПРАВО */
            else if(unitTile.wIndex < underTile.wIndex)
            {
//                trace("ВПРАВО");
                for (var r:int = unitTile.wIndex+1; r <= wDist+unitTile.wIndex; r++)
                {
                    // если есть ограничения
                    if(availableLayers != null)
                    {
                        curTile = groundArray[r][unitTile.hIndex];
                        isAval = false;
                        for each(var layer2:int in availableLayers)
                        {
                            if(isAval == false) isAval = (curTile.groundType == layer2);
                        }

                        if(isAval && calculateNeedWalk(drillSpeed, curTile))
                        {
//                            if(r == unitTile.wIndex+1)  path.push(groundArray[r][unitTile.hIndex]);
//                            else if(wrongPath.length < 1)  path.push(groundArray[r][unitTile.hIndex]);
                            if(wrongPath.length < 1) path.push(curTile);
                        }
                        else
                        {
                            if(wrongPath.indexOf(curTile) == -1) wrongPath.push(curTile);
                        }

                        // сохраняем как предыдущий результат
                        if(r != unitTile.wIndex+1)
                        {
                            prevIsAval = isAval;
                        }
                    }
                }
            }
        }
        // если юнит ходит только горизонально - построение пути вверх и вниз ограничиваем
        else if(!isHorisonralUnit)
        {
            // если временный путь вертикальный...
            if(underTile.wIndex == unitTile.wIndex)
            {
                hDist = Math.abs(unitTile.hIndex - underTile.hIndex);
    //            trace("hDist : " + hDist);
                /* ВНИЗ */
                if(unitTile.hIndex < underTile.hIndex)
                {
                    for (var d:int = unitTile.hIndex+1; d <= hDist+unitTile.hIndex; d++)
                    {
                        // если есть ограничения
                        if(availableLayers != null)
                        {
                            curTile = groundArray[unitTile.wIndex][d];
                            isAval = false;
                            for each(var layer3:int in availableLayers)
                            {
                                if(isAval == false) isAval = (curTile.groundType == layer3);
                            }

                            if(isAval && calculateNeedWalk(drillSpeed, curTile))
                            {
    //                            if(d == unitTile.hIndex+1) path.push(groundArray[unitTile.wIndex][d]);
    //                            else if(wrongPath.length < 1)  path.push(groundArray[unitTile.wIndex][d]);
                                if(wrongPath.length < 1) path.push(curTile);
                            }
                            else
                            {
                                if(wrongPath.indexOf(curTile) == -1) wrongPath.push(curTile);
                            }

                            // сохраняем как предыдущий результат
                            if(d != unitTile.hIndex+1)
                            {
                                prevIsAval = isAval;
                            }
                        }
                    }
                }
                // если путь идёт вверх
                /* ВВЕРХ */
                else if(unitTile.hIndex > underTile.hIndex)
                {
                    for (var u:int = unitTile.hIndex-1; u >= underTile.hIndex; u--)
                    {
                        // если есть ограничения
                        if(availableLayers != null)
                        {
                            curTile = groundArray[unitTile.wIndex][u];
                            isAval = false;
                            for each(var layer4:int in availableLayers)
                            {
                                if(isAval == false) isAval = curTile.groundType == layer4;
                            }

                            if(isAval && calculateNeedWalk(drillSpeed, curTile))
                            {
    //                             if(u == unitTile.hIndex-1) path.push(groundArray[unitTile.wIndex][u]);
    //                             else if(wrongPath.length < 1) path.push(groundArray[unitTile.wIndex][u]);
                                if(wrongPath.length < 1) path.push(curTile);
                            }
                            else
                            {
                                if(wrongPath.indexOf(curTile) == -1) wrongPath.push(curTile);
                            }

                            // сохраняем как предыдущий результат
                            if(u != unitTile.hIndex-1)
                            {
                                prevIsAval = isAval;
                            }
                        }
                    }
                }
            }
        }


        // если временный путь горизонтальный...
//        trace("temp path length : " + path.length);
//        if(_wrongPath) trace("inaccessiblePath length : " + _wrongPath.length);
        return path;
    }

    /* CALCULATE NEED WALK */
    private function calculateNeedWalk(drillSpeed:int, groundTile:GroundTile):Boolean
    {
        var needToWalkPoints:int = groundTile.groundType - drillSpeed;
        if(needToWalkPoints < 1) needToWalkPoints = 1;
        // если тайл уже перекопан
        if(!groundTile.isFull ) needToWalkPoints = 1;
        _totalWalkPoints -= needToWalkPoints;
        groundTile.walkPoints = needToWalkPoints;
        return _totalWalkPoints >= 0;
    }

    public function get tempPath():Vector.<GroundTile>
    {
        if(_tempPath == null) _tempPath = new Vector.<GroundTile>();
        return _tempPath;
    }
    public function set tempPath(value:Vector.<GroundTile>):void {_tempPath = value;}

    public function get unitTile():GroundTile {return _unitTile;}
    public function set unitTile(value:GroundTile):void {_unitTile = value;}

    public function get nodeTile():GroundTile {return _nodeTile;}
    public function set nodeTile(value:GroundTile):void {_nodeTile = value;}

    public function get totalTempPath():Vector.<GroundTile>
    {
        if(_totalTempPath == null) _totalTempPath = new Vector.<GroundTile>();
        return _totalTempPath;
    }
    public function set totalTempPath(value:Vector.<GroundTile>):void {_totalTempPath = value;}

    public function get wrongPath():Vector.<GroundTile>
    {
        if(_wrongPath == null)  _wrongPath = new Vector.<GroundTile>();
        return _wrongPath;
    }

    public function set wrongPath(value:Vector.<GroundTile>):void {
        _wrongPath = value;
    }
}
}
