/**
 * Created by Sith on 05.08.14.
 */
package MVC.buildings
{
import MVC.buildings.ABuilding;

import flash.display.MovieClip;
import flash.events.MouseEvent;

/* ФАБРИКА РОБОТОВ */
public class RobotFactory extends ABuilding
{
    /*CONSTRUCTOR*/
    public function RobotFactory(visionRange:int, health:int, id:int, view:MovieClip)
    {
        super(visionRange, health, view, id);
    }
}
}
