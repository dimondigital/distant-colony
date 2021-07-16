/**
 * Created by Sith on 20.03.14.
 */
package preloader
{
import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.Stage;
import flash.events.Event;
import flash.events.ProgressEvent;
import flash.utils.getDefinitionByName;



public class Preloader extends MovieClip
{

    public var _stage:Stage;

    private var _view:McPreloader;

    private var _sitelocks:Array = ["http://www.flashgamelicense.com", "https://www.flashgamelicense.com", "www.fgl.com"];

    /* CONSTRUCTOR */
    public function Preloader()
    {
        super();
        trace("PRELOADER :  start");
        stop();


//        stage.scaleMode = StageScaleMode.NO_SCALE;
//        stage.align = StageAlign.TOP_LEFT;

        startLoad();
//        checkForSitelock();
    }

    /* CHECK FOR SITELOCK */
    private function checkForSitelock():void
    {
        trace("PRELOADER : check for site lock");
        var url:String=stage.loaderInfo.url;
        var isStart:Boolean;
        for each(var sitelock:String in _sitelocks)
        {
            if(this.loaderInfo.url.indexOf(sitelock) != -1) isStart = true;
        }

        if(isStart) startLoad();
    }

    /* START LOAD */
    private function startLoad():void
    {
        _view = new McPreloader();
        addChild(_view);
        _view.stop();
        trace("PRELOADER : start load");
        root.loaderInfo.addEventListener(ProgressEvent.PROGRESS, loadingProgress);
        root.loaderInfo.addEventListener(Event.COMPLETE, loadingComplete);
    }

    /* LOADING PROGRESS */
    private function loadingProgress(e:ProgressEvent):void
    {
        var bytesTotal:Number = root.loaderInfo.bytesTotal;
        var bytesLoaded:Number = root.loaderInfo.bytesLoaded;
        var percent:int = Math.ceil((bytesLoaded/bytesTotal) * 10);
        _view["bar"].gotoAndStop(percent);
//        trace("PRELOADER : bytesTotal : " + bytesTotal);
//        trace("PRELOADER : bytesLoaded : " + bytesLoaded);
    }

    /* LOADING COMPLETE */
    private function loadingComplete(e:Event):void
    {
        trace("PRELOADER : LOADING COMPLETE");

        root.loaderInfo.removeEventListener(ProgressEvent.PROGRESS, loadingProgress);
        root.loaderInfo.removeEventListener(Event.COMPLETE, loadingComplete);

        nextFrame();
        initMain();
    }

    /* INIT MAIN */
    private function initMain():void
    {
        removeChild(_view);
        var mainClass:Class = getDefinitionByName("DistantColony") as Class;
        var main:Object = new mainClass(this);
        addChild(main as DisplayObject);

    }
}
}
