/**
 * Created by Sith on 05.08.14.
 */
package events
{
import MVC.AContent;
import MVC.ISelectable;

import flash.events.Event;

public class SelectEvent extends Event
{
    public static const SELECT:String = "select";
    public static const DESELECT:String = "deselect";

    private var _selectedObject:AContent;
    /*CONSTRUCTOR*/
    public function SelectEvent(selectedObject:AContent, type:String,bubbles:Boolean = false,cancelable:Boolean = false)
    {
        super(type, bubbles, cancelable);
        _selectedObject = selectedObject;
    }

    public function get selectedObject():AContent {return _selectedObject;}
}
}
