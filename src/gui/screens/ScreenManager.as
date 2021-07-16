/**
 * Created by Sith on 18.03.14.
 */
package gui.screens
{
import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.display.Stage;
import flash.ui.Mouse;
import gui.cursor.CustomCursor;


public class ScreenManager extends Sprite
{
    private var _prevScreen:IScreen;
    private var _screenCounter:int = 0;
    private var _totalScreen:Sprite;
    private var _stage:Stage;

    public var  mainMenuScreen:MainMenu;
//    public var  myLogoScreen:AScreen;
//    public var  sponsorLogoScreen:AScreen;
    public var  levelScreen:LevelScreen;
//    public var  videoScreen:VideoScreen;
//    public var  chooseControllerScreen:ScreenChooseController;
//    public var  guildScreen:GuildScreen;

    public static const MAIN_MENU:String = "mainMenu";
    public static const MY_LOGO:String = "myLogo";
    public static const SPONSOR_LOGO:String = "sponsorLogo";
    public static const LEVEL_SCREEN:String = "levelScreen";
    public static const VIDEO_SCREEN:String = "videoScreen";
    public static const CHOOSE_CONTROLLER_SCREEN:String = "chooseControllerScreen";
    public static const GUILD_SCREEN:String = "guildScreen";

    private var _customCursor:CustomCursor;

    /* SINGLETON */
    private static var _instance:ScreenManager;
    public static function get instance():ScreenManager
    {
        if(_instance == null) _instance = new ScreenManager();
        return _instance;
    }

    /* CONSTRUCTOR */
    public function ScreenManager()
    {

    }

    /* STATIC INIT */
    public static function init(preloader:DisplayObject):void
    {
        instance._stage = preloader.stage;
        instance._totalScreen = new Sprite();
        instance._stage.addChild(instance._totalScreen);

        instance.init();
    }

    /* INIT */
    private function init():void
    {
        mainMenuScreen          = new MainMenu(MAIN_MENU, new ScrMainMenu(), true);
//        myLogoScreen            = new AScreen(MY_LOGO, new MyLogoScreenMc(), mainMenuScreen, false);
//        sponsorLogoScreen       = new AScreen(SPONSOR_LOGO, new SponsorLogoMc(), myLogoScreen, false);
        levelScreen             = new LevelScreen(LEVEL_SCREEN, new MovieClip(), true, _stage, _totalScreen);
//        videoScreen             = new VideoScreen(VIDEO_SCREEN, new ScrVideoScreenMc(), levelScreen, true);
//        chooseControllerScreen  = new ScreenChooseController(CHOOSE_CONTROLLER_SCREEN, new ScreenChooseControllerMc(), true);
//        guildScreen             = new GuildScreen(GUILD_SCREEN, new ScrGuildMc(), true);

        _customCursor = new CustomCursor();
    }

    public static function show(screenName:String):void
    {
        switch (screenName)
        {
            case MAIN_MENU:                 instance.show(instance.mainMenuScreen);break;
//            case MY_LOGO:                   instance.show(instance.myLogoScreen);break;
//            case SPONSOR_LOGO:              instance.show(instance.sponsorLogoScreen);break;
            case LEVEL_SCREEN:              instance.show(instance.levelScreen);break;
//            case VIDEO_SCREEN:              instance.show(instance.videoScreen);break;
//            case CHOOSE_CONTROLLER_SCREEN:  instance.show(instance.chooseControllerScreen);break;
//            case GUILD_SCREEN:              instance.show(instance.guildScreen);break;
        }
    }

    /* SHOW */
    public function show(screen:IScreen):void
    {
        // если это первый скрин игры
        if(_screenCounter == 0)
        {
            _prevScreen = screen;
            _screenCounter++;
            _totalScreen.addChild(screen.view);
        }
        else
        {
            _prevScreen.deactivate();
            // прячем предыдущий скрин
            hide(_prevScreen);
            _prevScreen = screen;
            screen.gotoStartPos();
            _totalScreen.addChild(screen.view);
        }
        if(screen.isShowingMouseCursor)
        {
            Mouse.show();
        }
        else Mouse.hide();
    }

    /* HIDE */
    private function hide(screen:IScreen):void
    {
        _totalScreen.removeChild(screen.view);
    }

    public function set stage(value:Stage):void {_stage = value;}
}


}

