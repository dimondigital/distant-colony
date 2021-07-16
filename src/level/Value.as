/**
 * Created by Sith on 06.08.14.
 */
package level
{
import MVC.players.PlayerModel;

public class Value
{
    public static const SILICON:int = 1; // Кремний
    public static const ALUMINUM:int = 2; // Алюминий
    public static const TITANIUM:int = 3; // Титан
    public static const GOLD:int = 4; // Золото
    public static const TUNGSTEN:int = 5; // Вольфрам
    public static const RARE:int = 6; // Редкоземельные

    public static const SMALL:int = 1;
    public static const MID:int = 2;
    public static const LARGE:int = 3;

    private var _fulledType:int;

    private var _silicon:int;
    private var _aluminum:int;
    private var _titanium:int;
    private var _gold:int;
    private var _tungsten:int;
    private var _rare:int;

    private var _values:Array;

    /*CONSTRUCTOR*/
    public function Value(fulledType:int=0, silicon:int=0, aluminum:int=0, titanium:int=0, gold:int=0, tungsten:int=0, rare:int=0)
    {
        _fulledType = fulledType;
        _silicon = silicon;
        _aluminum = aluminum;
        _titanium = titanium;
        _gold = gold;
        _tungsten = tungsten;
        _rare = rare;

        _values = [_silicon, _aluminum, _titanium, _gold, _tungsten, _rare];
    }

    /* ADD METAL */
    public static function addMetal(value:Value, model:PlayerModel):void
    {
        model.silicon += value.silicon;
        model.aluminum += value.aluminum;
        model.titanium += value.titanium;
        model.gold += value.gold;
        model.tungsten += value.tungsten;
        model.rare += value.rare;
    }

    /* GET VALUE */
    public static function getValue(groundType:int):Value
    {
        var value:Value;
        var currentFulled:int;
        var fullType:int;  // тип наполненности
        var randomFulled:Number = Math.random();

        if(randomFulled < 0.1)
        {
            currentFulled = (Math.ceil(Math.random() * 5)) + 17;
            fullType = LARGE;
        }
        else if(randomFulled > 0.1 && randomFulled < 0.3)
        {
            currentFulled = (Math.ceil(Math.random() * 5)) + 12;
            fullType = MID;
        }
        else if(randomFulled > 0.3)
        {
            currentFulled = (Math.ceil(Math.random() * 5)) + 7;
            fullType = SMALL;
        }

        // проценты
        var sixty:int = Math.ceil(currentFulled*0.6);
        var fifty:int =  Math.ceil(currentFulled*0.5);
        var forty:int =  Math.ceil(currentFulled*0.4);
        var thirty:int =  Math.ceil(currentFulled*0.3);
        var twenty:int =  Math.ceil(currentFulled*0.2);
        var ten:int =  Math.ceil(currentFulled*0.1);

        switch (groundType)
        {
            case GroundTile.LAYER_1:
                   value = new Value(fullType, sixty, thirty, ten);
                break;
            case GroundTile.LAYER_2:
                    value = new Value(fullType, 0, fifty, forty, ten);
                break;
            case GroundTile.LAYER_3:
                    value = new Value(fullType, 0, 0, fifty, thirty, twenty);
                break;
            case GroundTile.LAYER_4:
                    value  = new Value(fullType, 0, 0, 0, fifty, thirty, twenty);
                break;
        }

        return value;
    }

    public function get silicon():int {return _silicon;}

    public function get aluminum():int {return _aluminum;}

    public function get titanium():int {return _titanium;}

    public function get gold():int {return _gold;}

    public function get tungsten():int {return _tungsten;}

    public function get rare():int {return _rare;}

    public function get fulledType():int {return _fulledType;}

    public function get values():Array {return _values;}
}
}
