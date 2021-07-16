/**
 * Created by Sith on 26.06.14.
 */
package MVC
{
public class ClipLabel
{
    public static const STAND:String = "stand";
    public static const RUN:String = "run";
    public static const WALK:String = "walk";
    public static const DEATH:String = "death";
    public static const BORN:String = "born";
    public static const FLY_UP:String = "flyUp";
    public static const FLY_DOWN:String = "flyDown";

    private var _name:String;
    private var _labelTotalFrames:int;
    private var _animationSpeed:Number;
    private var _isAlreadyPlayed:Boolean;
    private var _callbackFunction:Function;
    private var _nextLabel:String;

    public function ClipLabel(name:String, labelTotalFrames:int, animationSpeed:Number)
    {
        _name = name;
        _labelTotalFrames = labelTotalFrames;
        _animationSpeed = animationSpeed;
    }

    /* GET CLIP LABELS */
    public static function getClipLabels(clipLabels:Array):Vector.<ClipLabel>
    {
        var allClipLabels:Vector.<ClipLabel> = new Vector.<ClipLabel>();
        for(var i:int = 0; i < clipLabels.length; i++)
        {
            var clipLabel:ClipLabel = new ClipLabel(clipLabels[i][0], clipLabels[i][1], clipLabels[i][2]);
            allClipLabels.push(clipLabel);
        }
        return allClipLabels;
    }

    public function get name():String {return _name;}

    public function get labelTotalFrames():int {return _labelTotalFrames;}

    public function get animationSpeed():Number {return _animationSpeed;}

    public function get isAlreadyPlayed():Boolean {return _isAlreadyPlayed;}

    public function set isAlreadyPlayed(value:Boolean):void {_isAlreadyPlayed = value;}

    public function get callbackFunction():Function {return _callbackFunction;}

    public function set callbackFunction(value:Function):void {_callbackFunction = value;}

    public function get nextLabel():String {
        return _nextLabel;
    }

    public function set nextLabel(value:String):void {
        _nextLabel = value;
    }
}
}
