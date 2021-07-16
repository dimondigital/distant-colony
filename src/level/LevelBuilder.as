/**
 * Created by Sith on 04.08.14.
 */
package level
{
import flash.display.Sprite;

public class LevelBuilder
{
    private var _levelWidth:int;
    private var _levelHeight:int;

    private var _callback:Function;
    private var _levelObject:LevelObject;

    private var _levelSprite:Sprite;

    /*CONSTRUCTOR*/
    public function LevelBuilder(levelWidth:int, levelHeight:int, callback:Function, levelObject:LevelObject)
    {
        _levelWidth = levelWidth;
        _levelHeight = levelHeight;
        _callback = callback;
        _levelObject = levelObject;
    }

    /* START BUILD */
    public function startBuild():void
    {
        _levelSprite = new Sprite();
        initUp();
        initGround();

        _callback(_levelObject, _levelSprite);
    }

    /* INIT UP */
    private function initUp():void
    {
        _levelSprite.addChild(new McLevelUp());
    }

    /* INIT GROUND */
    private function initGround():void
    {
        var groundTilesArray:Vector.<Vector.<GroundTile>> = new Vector.<Vector.<GroundTile>>();
        for (var w:int = 0; w < _levelWidth; w++)
        {
           groundTilesArray[w] = new Vector.<GroundTile>();
            for (var h:int = 0; h < _levelHeight; h++)
            {
                // алгоритм наслоения грунтов
                var groundType:int;
                var random:Number = Math.random();
                if(h <= 6)
                {
                    groundType = 0;
                }
                else if(h == 7)
                {
                    groundType = -1;
                }
                else if(h <= 12)
                {
                    if(random < 0.75) groundType = 1;
                    else              groundType = 2;
                    // первые два уровня сделать исключительно 1-го уровня
                    if(h <= 9)  groundType = 1;
                }
                else if(h <= 17)
                {
                    if(random < 0.75) groundType = 2;
                    else              groundType = 3;

                    if(h <= 14)  groundType = 2;
                }
                else if(h <= 22)
                {
                    if(random < 0.75) groundType = 3;
                    else              groundType = 4;

                    if(h <= 19)  groundType = 3;
                }
                else if (h <= 27)
                {
                    if(random < 0.75) groundType = 4;
                    else              groundType = 3;

                    if(h <= 24)  groundType = 4;
                }
                else
                {
                    groundType = 0;
                }
                // наполнитель
                var value:Value;
                var randomValue:Number = Math.random();
                // тайл наполнен с 50-й вероятностью
                if(randomValue >  0.5 && groundType > 0)
                {
                    value = Value.getValue(groundType);
                }
                else
                {
                    value = null;
                }


                groundTilesArray[w][h] = new GroundTile(w*DistantColony.TILE_SIZE, h*DistantColony.TILE_SIZE, 0, groundType, w, h, value);
                if(groundType != 0) groundTilesArray[w][h].visibleState = 3;
                else groundTilesArray[w][h].visibleState = 2;
                _levelSprite.addChild(groundTilesArray[w][h].view);
            }
        }
        _levelObject.groundArray = groundTilesArray;
    }


}
}
