
/**
 * Created by Sith on 08.08.14.
 */
package loc {
public class Locale
{
    private static var _gameDesc:XML;

    [Embed(source='../loc/gameDescription.xml', mimeType="application/octet-stream")]
    private static var gameDescription:Class;


    /*CONSTRUCTOR*/
    public function Locale()
    {
    }

    public static function getCaption(key:String):String
    {
        var caption:String;
        if(_gameDesc == null) _gameDesc = new XML(new gameDescription);
        caption = String(_gameDesc[key].caption);
        return caption;
    }

    public static function getColor(key:String):String
    {
        var color:String;
        if(_gameDesc == null) _gameDesc = new XML(new gameDescription);
        color = String(_gameDesc[key].captionColor);
        return color;
    }

    public static function getDesc(key:String):String
    {
        var desc:String;
        if(_gameDesc == null) _gameDesc = new XML(new gameDescription);
        desc = String(_gameDesc[key].description);
        return desc;
    }

    public static function getWarning(key:String):String
    {
        var warn:String;
        if(_gameDesc == null) _gameDesc = new XML(new gameDescription);
        warn = String(_gameDesc[key].warning);
        return warn;
    }


}
}
