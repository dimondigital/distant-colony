/**
 * Created by Sith on 05.08.14.
 */
package MVC.buildings
{
import MVC.buildings.ABuilding;

import flash.display.MovieClip;

/* ШТАБ */
public class Headquaters extends ABuilding
{

    /*CONSTRUCTOR*/
    public function Headquaters(visionRange:int, health:int, id:int)
    {
        var view:MovieClip = new McHeadquaters();
        super(visionRange, health, view, id);
    }
}
}
