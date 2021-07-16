/**
 * Created by Sith on 06.08.14.
 */
package MVC.units {
import level.GroundTile;

public interface IPath
{
    function drawPath(groundArray:Vector.<Vector.<GroundTile>>=null):void
    function updatePath(underTile:GroundTile, drillSpeed:int, walkPoints:int):void
    function moveByPath(endAnimationCallback:Function, stepEndCallback:Function):void
    function get tempPath():Vector.<GroundTile>
    function set tempPath(newGroundTile:Vector.<GroundTile>):void
    function get totalTempPath():Vector.<GroundTile>
    function set totalTempPath(newGroundTile:Vector.<GroundTile>):void
    function get wrongPath():Vector.<GroundTile>
    function set wrongPath(newGroundTile:Vector.<GroundTile>):void
    function get unitTile():GroundTile
    function get nodeTile():GroundTile
    function set nodeTile(newGroundTile:GroundTile):void
}
}
