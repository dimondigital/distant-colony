/**
 * Created by Sith on 05.08.14.
 */
package MVC.players
{
import MVC.AContent;
import MVC.GameView;
import MVC.buildings.ABuilding;
import MVC.buildings.ExplorerCenter;
import MVC.buildings.Headquaters;
import MVC.buildings.RobotFactory;
import MVC.units.AUnit;
import MVC.units.Drill;
import MVC.units.Soldier;

import actions.Action;
import actions.Build;
import actions.HireUnit;

import flash.printing.PrintJob;

import flash.utils.Dictionary;

import level.GroundTile;
import level.Value;

import sound.SoundManager;

public class PlayerModel implements IPlayerModel
{
    private var _playerInterface:IPlayerView;
    private var _gameView:GameView;
    // сделать из массивов словари
    private var _contents:Vector.<AContent>;   // все сущности игрока (все здания и юниты)
    private var _buildings:Vector.<ABuilding>;
    private var _units:Vector.<AUnit>;
    private var _walkPoints:int = 10;
    private var _id:int; // номер игрока

    //металлы
    /*private var _silicon:int = 500;   // кремний
    private var _aluminum:int = 500;  // алюминий
    private var _titanium:int = 500;  // титан
    private var _gold:int = 500;  // золото
    private var _tungsten:int = 500;  // вольфрам
    private var _rare:int = 500;  // редкоземельные металлы*/

    private var _silicon:int;   // кремний
    private var _aluminum:int;  // алюминий
    private var _titanium:int;  // титан
    private var _gold:int;  // золото
    private var _tungsten:int;  // вольфрам
    private var _rare:int;  // редкоземельные металлы

    private var _resources:Array = [_silicon, _aluminum, _titanium, _gold, _tungsten, _rare];

    public static const SILICON:String = "silicon";
    public static const ALUMINUM:String = "aluminum";
    public static const TITANIUM:String = "titanium";
    public static const GOLD:String = "gold";
    public static const TUNGSTEN:String = "tungsten";
    public static const RARE:String = "rare";

    // drill (навыки буровой машины, которые можно улучшать со временем)
    private var _avalGroundTypes:Array = [GroundTile.LAYER_1]; // доступные для бурения грунты (макс +3)
    private var _drillingSpeed:int = 0;     // скорость сверления (макс +3)

    // actions
    private var _actions:Dictionary;

        /* DRILL */
        public static const DRILL:String = "drill";
        // drill vision range
        public static const EXPLORE_DRILL_VISION_RANGE1:String = "exploreDrillVisionRange1";
        public static const EXPLORE_DRILL_VISION_RANGE2:String = "exploreDrillVisionRange2";
        public static const EXPLORE_DRILL_VISION_RANGE3:String = "exploreDrillVisionRange3";
        // drill speed
        public static const EXPLORE_DRILL_SPEED1:String = "exploreDrillSpeed1";
        public static const EXPLORE_DRILL_SPEED2:String = "exploreDrillSpeed2";
        public static const EXPLORE_DRILL_SPEED3:String = "exploreDrillSpeed3";
        // drill aval ground
        public static const EXPLORE_DRILL_AVAL_GROUND1:String = "exploreDrillAvalGround1";
        public static const EXPLORE_DRILL_AVAL_GROUND2:String = "exploreDrillAvalGround2";
        public static const EXPLORE_DRILL_AVAL_GROUND3:String = "exploreDrillAvalGround3";

        /* HQ */
        public static const HQ:String = "hq";

        public static const BUILD_ROBOT_FACTORY:String = "buildRobotFactoty";
        public static const BUILD_EXPLORER_CENTER:String = "buildExplorerCenter";

        /* ROBOT FACTORY */
        public static const ROBOT_FACTORY:String = "robotFactory";

        public static const HIRE_SOLDIER:String = "hireSoldier";

    private var _actionKeys:Array = [EXPLORE_DRILL_VISION_RANGE1, EXPLORE_DRILL_VISION_RANGE2, EXPLORE_DRILL_VISION_RANGE3,
                                     EXPLORE_DRILL_SPEED1, EXPLORE_DRILL_SPEED2, EXPLORE_DRILL_SPEED3,
                                     EXPLORE_DRILL_AVAL_GROUND1, EXPLORE_DRILL_AVAL_GROUND2, EXPLORE_DRILL_AVAL_GROUND3,
                                     BUILD_ROBOT_FACTORY, BUILD_EXPLORER_CENTER, HIRE_SOLDIER];

    /*CONSTRUCTOR*/
    public function PlayerModel(id:int, gameView:GameView)
    {
        _id = id;
        _gameView = gameView;

        _contents = new Vector.<AContent>();
        _buildings = new Vector.<ABuilding>();
        _units = new Vector.<AUnit>();

        _actions = new Dictionary();
        /* drill */
        _actions[EXPLORE_DRILL_VISION_RANGE1] = new Action(DRILL, EXPLORE_DRILL_VISION_RANGE1, new Value(0, 20, 20, 5), true, false, explore);
        _actions[EXPLORE_DRILL_VISION_RANGE2] = new Action(DRILL, EXPLORE_DRILL_VISION_RANGE2, new Value(0, 30, 30, 10), false, false, explore);
        _actions[EXPLORE_DRILL_VISION_RANGE3] = new Action(DRILL, EXPLORE_DRILL_VISION_RANGE3, new Value(0, 20, 0, 20, 10), false, false, explore);

        _actions[EXPLORE_DRILL_SPEED1] = new Action(DRILL, EXPLORE_DRILL_SPEED1, new Value(0, 20, 20, 10), true, false, explore);
        _actions[EXPLORE_DRILL_SPEED2] = new Action(DRILL, EXPLORE_DRILL_SPEED2, new Value(0, 10, 30, 20), false, false, explore);
        _actions[EXPLORE_DRILL_SPEED3] = new Action(DRILL, EXPLORE_DRILL_SPEED3, new Value(0, 20, 0, 0, 30), false, false, explore);

        _actions[EXPLORE_DRILL_AVAL_GROUND1] = new Action(DRILL, EXPLORE_DRILL_AVAL_GROUND1, new Value(0, 50, 50, 0), true, false, explore);
        _actions[EXPLORE_DRILL_AVAL_GROUND2] = new Action(DRILL, EXPLORE_DRILL_AVAL_GROUND2, new Value(0, 20, 40, 40), false, false, explore);
        _actions[EXPLORE_DRILL_AVAL_GROUND3] = new Action(DRILL, EXPLORE_DRILL_AVAL_GROUND3, new Value(0, 0, 0, 30, 30, 20), false, false, explore);

        /* hq */
        _actions[BUILD_ROBOT_FACTORY] = new Build(new McRobotFactory(), HQ, BUILD_ROBOT_FACTORY, new Value(0, 50, 100, 0, 50), true, false, build, gameView, _buildings, _resources);
        _actions[BUILD_EXPLORER_CENTER] = new Build(new McExplorerCenter(), HQ, BUILD_EXPLORER_CENTER, new Value(0, 0, 50, 25, 25), true, false, build, gameView, _buildings, _resources);

        /* robot factory */
        _actions[HIRE_SOLDIER] = new HireUnit(McSoldier, ROBOT_FACTORY, HIRE_SOLDIER, new Value(0, 20, 10, 100), true, false, hire, gameView, _buildings, _resources);

    }

    /* INIT START CONTENT */
    public function initStartContent():void
    {

        var hq:Headquaters = new Headquaters(6, 100, _id);
        _contents.push(hq);
        _buildings.push(hq);

        var drill:Drill = new Drill(3, 100, _id, _avalGroundTypes);
        _contents.push(drill);
        _units.push(drill);
    }

    /* INIT VIEW */
    public function initInterface(view:IPlayerView):void
    {
        _playerInterface = view;
    }

    /* HIRE UNIT */
    public function hire(hired:HireUnit):void
    {
        trace("hired : " + hired.name);
        if(enoughResources(hired, _resources))
        {
            switch (hired.name)
            {
                case HIRE_SOLDIER:
                    var soldier:Soldier = new Soldier(4, 200, _id, 25, hired.buildView);
                    _contents.push(soldier);
                    _units.push(soldier);
                    _gameView.updateDark();
                    break;
            }
            hired.isExplored = true;
            updateResources(hired);
        }
    }

    /* BUILD */
    public function build(build:Build):void
    {
        trace("build : " + build.name);
        if(enoughResources(build, _resources))
        {
            switch (build.name)
            {
                case BUILD_ROBOT_FACTORY:
                        var robotFactory:RobotFactory = new RobotFactory(6, 300, _id, build.buildView);
                        _contents.push(robotFactory);
                        _buildings.push(robotFactory);
                        _gameView.updateDark();
                    break;
                case BUILD_EXPLORER_CENTER:
                        var explorerCenter:ExplorerCenter = new ExplorerCenter(4, 150, _id, build.buildView);
                        _contents.push(explorerCenter);
                        _buildings.push(explorerCenter);
                        // становятся доступны некоторые исследования
                        _actions[EXPLORE_DRILL_VISION_RANGE2].isAval = true;
                        _actions[EXPLORE_DRILL_SPEED2].isAval = true;
                        _actions[EXPLORE_DRILL_AVAL_GROUND2].isAval = true;
                        _gameView.updateDark();
                    break;
            }
            _gameView.build(build.buildView.x, build.buildView.y, build.buildView.width, build.buildView.height);
            build.isExplored = true;
            updateResources(build);
        }
    }

    /* EXPLORE */
    public function explore(action:Action):void
    {
        if(enoughResources(action, _resources))
        {
            switch (action.name)
            {
                case EXPLORE_DRILL_VISION_RANGE1:
                        Drill(_contents[1]).visionRange += 1;
                    break;
                case EXPLORE_DRILL_VISION_RANGE2:
                        Drill(_contents[1]).visionRange += 1;
                        _actions[EXPLORE_DRILL_VISION_RANGE3].isAval = true;
                    break;
                case EXPLORE_DRILL_VISION_RANGE3:
                        Drill(_contents[1]).visionRange += 1;
                    break;
                case EXPLORE_DRILL_SPEED1:
                        _drillingSpeed += 1;
                    break;
                case EXPLORE_DRILL_SPEED2:
                        _drillingSpeed += 1;
                    _actions[EXPLORE_DRILL_SPEED3].isAval = true;
                    break;
                case EXPLORE_DRILL_SPEED3:
                        _drillingSpeed += 1;
                    break;
                case EXPLORE_DRILL_AVAL_GROUND1:
                        _avalGroundTypes.push(GroundTile.LAYER_2);
                    break;
                case EXPLORE_DRILL_AVAL_GROUND2:
                        _avalGroundTypes.push(GroundTile.LAYER_3);
                        _actions[EXPLORE_DRILL_AVAL_GROUND3].isAval = true;
                    break;
                case EXPLORE_DRILL_AVAL_GROUND3:
                        _avalGroundTypes.push(GroundTile.LAYER_4);
                    break;
            }
            _gameView.explore();
            action.isExplored = true;
            updateResources(action);
        }
        else
        {
            trace ("Недостаточно ресурсов");
        }
    }

    /* ENOUGH RESOURCES */
    public static function enoughResources(action:Action, resources:Array):Boolean
    {
        for (var i:int = 0; i < resources.length; i++)
        {
            var avalRes:int = resources[i];
            var needRes:int = action.cost.values[i];
            if(needRes > avalRes) return false;
        }
        return true;
    }

    /* UPDATE RESOURCES */
    public function updateResources(action:Action):void
    {
        silicon -= action.cost.silicon;
        aluminum -= action.cost.aluminum;
        titanium -= action.cost.titanium;
        gold -= action.cost.gold;
        tungsten -= action.cost.tungsten;
        rare -= action.cost.rare;
    }

    public function get contents():Vector.<AContent> {return _contents;}

    public function get walkPoints():int {return _walkPoints;}
    public function set walkPoints(value:int):void
    {
        _walkPoints = value;
        if(_walkPoints < 0) _walkPoints = 0;
        _playerInterface.updateMovePoints();
    }

    public function get id():int {return _id;}

    public function get avalGroundTypes():Array {return _avalGroundTypes;}

    public function get silicon():int {return _silicon;}
    public function set silicon(value:int):void
    {
        _silicon = value;
        _resources[0] = _silicon;
        _playerInterface.updateMetalPanel(SILICON);
    }

    public function get aluminum():int {return _aluminum;}
    public function set aluminum(value:int):void
    {
        _aluminum = value;
        _resources[1] = _aluminum;
        _playerInterface.updateMetalPanel(ALUMINUM);
    }

    public function get titanium():int {return _titanium;}
    public function set titanium(value:int):void
    {
        _titanium = value;
        _resources[2] = _titanium;
        _playerInterface.updateMetalPanel(TITANIUM);
    }

    public function get gold():int {return _gold;}
    public function set gold(value:int):void
    {
        _gold = value;
        _resources[3] = _gold;
        _playerInterface.updateMetalPanel(GOLD);
    }

    public function get tungsten():int {return _tungsten;}
    public function set tungsten(value:int):void
    {
        _tungsten = value;
        _resources[4] = _tungsten;
        _playerInterface.updateMetalPanel(TUNGSTEN);
    }

    public function get rare():int {return _rare;}
    public function set rare(value:int):void
    {
        _rare = value;
        _resources[5] = _rare;
        _playerInterface.updateMetalPanel(RARE)
    }

    public function get drillingSpeed():int {
        return _drillingSpeed;
    }

    public function set drillingSpeed(value:int):void {
        _drillingSpeed = value;
    }

    public function get actions():Dictionary {
        return _actions;
    }

    public function get actionKeys():Array {
        return _actionKeys;
    }

    public function get resources():Array {
        return _resources;
    }
}
}
