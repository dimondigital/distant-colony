/**
 * Created by Sith on 05.08.14.
 */
package MVC.buildings
{
import MVC.buildings.ABuilding;

import flash.display.MovieClip;

/* ИССЛЕДОВАТЕЛЬСКИЙ ЦЕНТР */
public class ExplorerCenter extends ABuilding
{
    /*CONSTRUCTOR*/
    public function ExplorerCenter(visionRange:int, health:int, id:int, view:MovieClip)
    {
        super(visionRange, health, view, id);
    }
}
}
