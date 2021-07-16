/**
 * Created by Sith on 09.08.14.
 */
package actions
{
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.MouseEvent;

import level.Value;

/* общая структура для исследований, построек зданий и наёма юнитов. В общем любые действия, требующие определённых ресурсов */
public class Action
{
    private var _type:String;
    private var _name:String;
    private var _cost:Value;
    private var _isAval:Boolean;
    private var _isExplored:Boolean;

    protected var _warning:String = "";

    protected var _callbackAction:Function;
    protected var _view:MovieClip;
    private var _lockedIcon:McLockedIcon;
    private var _alreadyExploredIcon:McAlreadyExplored;
    private var _viewCont:Sprite;

    /*CONSTRUCTOR*/
    public function Action(type:String, name:String, cost:Value, isAval:Boolean, isExplored:Boolean, callbackAction:Function)
    {
        _type = type;
        _name = name;
        _cost = cost;
        _isAval = isAval;
        _isExplored = isExplored;
        _callbackAction = callbackAction;
    }

    /* INIT VIEW */
    public function initView(view:MovieClip, viewCont:Sprite):void
    {
        _view = view;
        _viewCont = viewCont;

        _lockedIcon = new McLockedIcon();
        _lockedIcon.x = _view.x;
        _lockedIcon.y = _view.y;
        _viewCont.addChild(_lockedIcon);
        _lockedIcon.visible = false;
        _lockedIcon.mouseChildren = false;
        _lockedIcon.mouseEnabled = false;

        _alreadyExploredIcon = new McAlreadyExplored();
        _alreadyExploredIcon.x = _view.x;
        _alreadyExploredIcon.y = _view.y;
        _viewCont.addChild(_alreadyExploredIcon);
        _alreadyExploredIcon.visible = false;
        _alreadyExploredIcon.mouseChildren = false;
        _alreadyExploredIcon.mouseEnabled = false;

        updateView();

        addListeners();
    }

    /* ADD LISTENERS */
    protected function addListeners():void
    {
        _view.addEventListener(MouseEvent.CLICK, onClick);
    }

    /* ON CLICK */
    protected function onClick(e:MouseEvent):void
    {
        if(!isExplored)
        {
            if(isAval)
            {
                _callbackAction(this);
            }
        }
        updateView();
    }

    /* UPDATE VIEW */
    public function updateView():void
    {
        // если доступно
        if(_isAval)
        {
            // если исследовано
            if(_isExplored)
            {
                _view.alpha = 0.25;
                _alreadyExploredIcon.visible = true;
            }
            else
            {
                _view.alpha = 1;
                _alreadyExploredIcon.visible = false;
            }
            _lockedIcon.visible = false;
        }
        else
        {
            _view.alpha = 0.25;
            _lockedIcon.visible = true;
        }
    }

    public function get isExplored():Boolean {return _isExplored;}
    public function set isExplored(value:Boolean):void
    {
        _isExplored = value;
        if(_view) updateView();
    }

    public function get isAval():Boolean {return _isAval;}
    public function set isAval(value:Boolean):void
    {
        _isAval = value;
        if(_view) updateView();
    }

    public function get cost():Value {return _cost;}
    public function set cost(value:Value):void {_cost = value;}

    public function get name():String {return _name;}
    public function set name(value:String):void {_name = value;}

    public function get type():String {
        return _type;
    }

    public function get warning():String {
        return _warning;
    }
}
}
