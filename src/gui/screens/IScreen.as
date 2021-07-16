/**
 * Created by Sith on 01.08.14.
 */
package gui.screens
{
import flash.display.MovieClip;
import flash.display.Sprite;

public interface IScreen
{
    function deactivate():void
    function get view():MovieClip
    function get isShowingMouseCursor():Boolean
    function get screenName():String
    function prepare():void
    function gotoStartPos():void
}
}
