/**
 * Created by Sith on 10.08.14.
 */
package MVC.units
{
import flash.display.MovieClip;

import utils.Direction;

/* юнит, передвигающийся только влево и вправо */
public class AHorizontalUnit extends AUnit
{
    /*CONSTRUCTOR*/
    public function AHorizontalUnit(visionRange:int, health:int, id:int, view:MovieClip)
    {
        super(visionRange, health, view, id);
    }

    /* UPDATE DIRECTION */
    // смена направления вида, в зависимости от направления
    protected function updateDirection():void
    {

        if(unitTile.wIndex > totalTempPath[totalTempPath.length-1].wIndex)  currentDirection = Direction.LEFT;
        else currentDirection = Direction.RIGHT;
    }



    public function get currentDirection():int {return _currentDirection;}
    public function set currentDirection(value:int):void
    {
        _currentDirection = value;
        if(_currentDirection ==  Direction.LEFT)  internalView.scaleX = -1;
        else                                      internalView.scaleX = 1;
    }

    // override set direction function
}
}
