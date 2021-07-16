/**
 * Created by Sith on 05.08.14.
 */
package MVC.buildings
{
import MVC.*;

import flash.display.MovieClip;
import flash.events.MouseEvent;

/* АБСТРАКТНОЕ ЗДАНИЕ */
public class ABuilding extends AContent
{
    /*CONSTRUCTOR*/
    public function ABuilding(visionRange:int, health:int, view:MovieClip, id:int)
    {
        super(visionRange, health, view, id);
    }
}
}
