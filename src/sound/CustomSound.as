/**
 * Created with IntelliJ IDEA.
 * User: work-04
 * Date: 30.04.14
 * Time: 16:40
 * To change this template use File | Settings | File Templates.
 */
package sound
{
import flash.media.Sound;
import flash.media.SoundChannel;

public class CustomSound extends Sound
{
    private var _name:String;
    private var _sound:Sound;
    private var _channel:SoundChannel;
    private var _position:Number = 0;
    private var _paused:Boolean = true;
    private var _volume:Number = 1;
    private var _startTime:Number = 0;
    private var _loops:int = 0;
    private var _pausedByAll:Boolean = false;

    public function CustomSound()
    {

    }

    public function get name():String{return _name;}
    public function set name(value:String):void{_name = value;}

    public function get sound():Sound{return _sound;}
    public function set sound(value:Sound):void{_sound = value;}

    public function get channel():SoundChannel{return _channel;}
    public function set channel(value:SoundChannel):void{_channel = value;}

    public function get position():Number{return _position;}
    public function set position(value:Number):void{_position = value;}

    public function get paused():Boolean{return _paused;}
    public function set paused(value:Boolean):void{_paused = value;}

    public function get volume():Number{return _volume;}
    public function set volume(value:Number):void{_volume = value;}

    public function get startTime():Number{return _startTime;}
    public function set startTime(value:Number):void{_startTime = value;}

    public function get loops():int{return _loops;}
    public function set loops(value:int):void{_loops = value;}

    public function get pausedByAll():Boolean{return _pausedByAll;}
    public function set pausedByAll(value:Boolean):void{_pausedByAll = value;}
}
}
