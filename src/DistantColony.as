package
{

import com.greensock.plugins.FramePlugin;
import com.greensock.plugins.RemoveTintPlugin;
import com.greensock.plugins.TintPlugin;
import com.greensock.plugins.TweenPlugin;
import flash.display.MovieClip;
import flash.display.Stage;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;

import gui.screens.ScreenManager;

import preloader.Preloader;

import sound.SoundManager;

[Frame(factoryClass="preloader.Preloader")]
[SWF(width="768", height="768", backgroundColor="#000000", frameRate="60")]
public class DistantColony extends MovieClip
{
    private var _preloader:Preloader;

    public static const SCALE_FACTOR:int = 3;
    public static const HEIGHT:int = 768 / SCALE_FACTOR;
    public static const WIDTH:int = 768 / SCALE_FACTOR;
    public static const TILE_SIZE:int = 16;

    TweenPlugin.activate([TintPlugin, RemoveTintPlugin, FramePlugin]);

    /* CONSTRUCTOR */
    public function DistantColony(preloader:Preloader)
    {
        _preloader = preloader;
        addEventListener(Event.ADDED_TO_STAGE, init);
    }

    /* INIT */
    private function init(e:Event):void
    {
        removeEventListener(Event.ADDED_TO_STAGE, init);
        trace("AppMain : INIT");
        ScreenManager.init(_preloader);
        ScreenManager.show(ScreenManager.MAIN_MENU);
        SoundManager.initSounds();
    }
}
}
