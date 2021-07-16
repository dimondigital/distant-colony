/**
 * Created by Sith on 04.08.14.
 */
package level {
import flash.geom.Point;

public class LevelObject
{
    private var _groundArray:Vector.<Vector.<GroundTile>> = new Vector.<Vector.<GroundTile>>();

    /*CONSTRUCTOR*/
    public function LevelObject()
    {

    }

    public static function getTileCoordinates(widthIndex:int, heightIndex:int):Point
    {
        var coordinates:Point = new Point(widthIndex * DistantColony.TILE_SIZE, heightIndex * DistantColony.TILE_SIZE);
        return coordinates;
    }

    public function getTileByCoordinates(x:Number, y:Number):GroundTile
    {
       var wIndex:int = Math.floor(x / DistantColony.TILE_SIZE);
        var hIndex:int = Math.floor(y / DistantColony.TILE_SIZE);
        if(wIndex >= 0 && hIndex >= 0 ) var tile:GroundTile = _groundArray[wIndex][hIndex];
        return tile;
    }

    public static function getTileByCoordinates(x:Number, y:Number, array:Vector.<Vector.<GroundTile>>):GroundTile
    {
        var wIndex:int = Math.floor(x / DistantColony.TILE_SIZE);
        var hIndex:int = Math.floor(y / DistantColony.TILE_SIZE);
        if(wIndex >= 0 && hIndex >= 0 )var tile:GroundTile = array[wIndex][hIndex];
        return tile;
    }

    public function get groundArray():Vector.<Vector.<GroundTile>> {return _groundArray;}
    public function set groundArray(value:Vector.<Vector.<GroundTile>>):void {_groundArray = value;}
}
}
