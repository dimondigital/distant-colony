/**
 * Created by Sith on 09.08.14.
 */
package MVC {
public interface IAttackable
{
    function get attackDamage():int
    function attack():void
    function get isCanAttack():Boolean
    function set isCanAttack(value:Boolean):void
}
}
