/**
 * Created with IntelliJ IDEA.
 * User: work-04
 * Date: 27.03.14
 * Time: 12:52
 * To change this template use File | Settings | File Templates.
 *
 * get from http://evolve.reintroducing.com/2008/07/15/as3/as3-soundmanager/
 *
 */
package sound
{
import com.greensock.TweenLite;
import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.media.SoundLoaderContext;
import flash.media.SoundTransform;
    import flash.net.URLRequest;
    import flash.utils.Dictionary;
    import flash.utils.getQualifiedClassName;

import sound.CustomSound;

/**
     * The SoundManager is a singleton that allows you to have various ways to control sounds in your project.
     * <p />
     * The SoundManager can load external or library sounds, pause/mute/stop/control volume for one or more sounds at a time,
     * fade sounds up or down, and allows additional control to sounds not readily available through the default classes.
     * <p />
     * This class is dependent on TweenLite (http://www.tweenlite.com) to aid in easily fading the volume of the sound.
     *
     * @author Matt Przybylski [http://www.reintroducing.com]
     * @version 1.0
     */
    public class SoundManager
    {
        //- PRIVATE & PROTECTED VARIABLES -------------------------------------------------------------------------

        // singleton instance
        private static var _instance:SoundManager;
        private static var _allowInstance:Boolean;

        private var _soundsDict:Dictionary;
        private var _sounds:Vector.<CustomSound>;

        private var _masterChannel:SoundChannel = new SoundChannel();

	    private var _isPlayingMusic:Boolean = true;
	    private var _isPlayingSounds:Boolean = true;

        //- PUBLIC & INTERNAL VARIABLES ---------------------------------------------------------------------------

        public static const MUSIC_1      :String = "music1";
        public static const DRILL_MOVE    :String = "drillMove";
        public static const DIG_GROUND       :String = "digGround";
        public static const SELECT       :String = "select";
        public static const EXPLOSIVE   :String = "explosive";
        public static const ROBOT_WALK   :String = "robotWalk";
        public static const ROBOT_TALK_1   :String = "robotTalk1";
        public static const ROBOT_TALK_2   :String = "robotTalk2";
        public static const ROBOT_TALK_3   :String = "robotTalk3";
        public static const BUILD   :String = "build";
        public static const EXPLORE   :String = "explore";

        //- CONSTRUCTOR -------------------------------------------------------------------------------------------

        // singleton instance of SoundManager
        public static function getInstance():SoundManager
        {
            if (_instance == null)
            {
                _allowInstance = true;
                _instance = new SoundManager();
                _allowInstance = false;
            }

            return _instance;
        }

        public function SoundManager()
        {
            this._soundsDict = new Dictionary(true);
            this._sounds = new Vector.<CustomSound>();

            if (!_allowInstance)
            {
                throw new Error("Error: Use SoundManager.getInstance() instead of the new keyword.");
            }
        }

        //- PRIVATE & PROTECTED METHODS ---------------------------------------------------------------------------



        //- PUBLIC & INTERNAL METHODS -----------------------------------------------------------------------------

        /* + + + CUSTOM METHODS*/
        /* INIT SOUNDS */
        public static function initSounds():void
        {
            /*var sounds:Array = [snd_ClickSmall, snd_Counting, snd_LeverDown, snd_LeverUp, snd_StartBtnDown, snd_Turn, snd_TurningEnd];
            for (var i:int = 0; i < sounds.length; i++)
            {
                var snd:* = sounds[i];
                snd.name = snd.toString();
                addLibrarySound(snd, snd.name);
            }*/
            addLibrarySound(Music1, MUSIC_1);
            addLibrarySound(SndDrillMove, DRILL_MOVE);
            addLibrarySound(SndDigGround, DIG_GROUND);
            addLibrarySound(SndSelect, SELECT);
            addLibrarySound(SndExplosive, EXPLOSIVE);
            addLibrarySound(SndRobotWalk, ROBOT_WALK);
            addLibrarySound(SndRobotTalk1, ROBOT_TALK_1);
            addLibrarySound(SndRobotTalk2, ROBOT_TALK_2);
            addLibrarySound(SndRobotTalk3, ROBOT_TALK_3);
            addLibrarySound(SndBuild, BUILD);
            addLibrarySound(SndExplore, EXPLORE);
        }

        /* GET SOUND CHIPS BY TOTAL AMOUNT */
        // определённый звук, в зависимости от количества фишек
        public static function getSoundChipsByTotalAmount(val:int):int
        {
            if(val == 1)                    return 0;
            else if(val > 1 && val < 5)     return 1;
            else                            return 2;
        }

        /**
         * Adds a sound from the library to the sounds dictionary for playing in the future.
         *
         * @param $linkageID The class name of the library symbol that was exported for AS
         * @param $name The string identifier of the sound to be used when calling other methods on the sound
         *
         * @return Boolean A boolean value representing if the sound was added successfully
         */
        public static function addLibrarySound($linkageID:*, $name:String):Boolean
        {
            for (var i:int = 0; i < getInstance()._sounds.length; i++)
            {
                if (getInstance()._sounds[i].name == $name) return false;
            }

            var sndObj:CustomSound = new CustomSound();
            var snd:Sound = new $linkageID;

            sndObj.name = $name;
            sndObj.sound = snd;
            sndObj.channel = new SoundChannel();
            sndObj.position = 0;
            sndObj.paused = true;
            sndObj.volume = 1;
            sndObj.startTime = 0;
            sndObj.loops = 0;
            sndObj.pausedByAll = false;

            getInstance()._soundsDict[$name] = sndObj;
            getInstance()._sounds.push(sndObj);

            return true;
        }

        public static function stopMusic():void
        {

        }

        /**
         * Adds an external sound to the sounds dictionary for playing in the future.
         *
         * @param $path A string representing the path where the sound is on the server
         * @param $name The string identifier of the sound to be used when calling other methods on the sound
         * @param $buffer The number, in milliseconds, to buffer the sound before you can play it (default: 1000)
         * @param $checkPolicyFile A boolean that determines whether Flash Player should try to download a cross-domain policy file from the loaded sound's server before beginning to load the sound (default: false)
         *
         * @return Boolean A boolean value representing if the sound was added successfully
         */
        public function addExternalSound($path:String, $name:String, $buffer:Number = 1000, $checkPolicyFile:Boolean = false):Boolean
        {
            for (var i:int = 0; i <this._sounds.length; i++)
            {
                if (this._sounds[i].name == $name) return false;
            }

            var sndObj:CustomSound = new CustomSound();
            var snd:Sound = new Sound(new URLRequest($path), new SoundLoaderContext($buffer, $checkPolicyFile));

            sndObj.name = $name;
            sndObj.sound = snd;
//            sndObj.channel = new SoundChannel();
            sndObj.position = 0;
            sndObj.paused = true;
            sndObj.volume = 1;
            sndObj.startTime = 0;
            sndObj.loops = 0;
            sndObj.pausedByAll = false;

            this._soundsDict[$name] = sndObj;
            this._sounds.push(sndObj);

            return true;
        }

        /**
         * Removes a sound from the sound dictionary.  After calling this, the sound will not be available until it is re-added.
         *
         * @param $name The string identifier of the sound to remove
         *
         * @return void
         */
        public function removeSound($name:String):void
        {
            for (var i:int = 0; i <this._sounds.length; i++)
            {
                if (this._sounds[i].name == $name)
                {
                    this._sounds[i] = null;
                    this._sounds.splice(i, 1);
                }
            }

            delete this._soundsDict[$name];
        }

        /**
         * Removes all sounds from the sound dictionary.
         *
         * @return void
         */
        public function removeAllSounds():void
        {
            for (var i:int = 0; i <this._sounds.length; i++)
            {
                this._sounds[i] = null;
            }

            this._sounds = new Vector.<CustomSound>();
            this._soundsDict = new Dictionary(true);
        }

        /**
         * Plays or resumes a sound from the sound dictionary with the specified name.
         *
         * @param $name The string identifier of the sound to play
         * @param $volume A number from 0 to 1 representing the volume at which to play the sound (default: 1)
         * @param $startTime A number (in milliseconds) representing the time to start playing the sound at (default: 0)
         * @param $loops An integer representing the number of times to loop the sound (default: 0)
         *
         * @return void
         */
        private var _nowPlayingSounds:Vector.<CustomSound> = new Vector.<CustomSound>();
        public static function playSound($name:String, $volume:Number = 1, $startTime:Number = 0, $loops:int = 0, randomStartTime:Boolean=false):void
        {
            var snd:CustomSound = getInstance()._soundsDict[$name];
            getInstance()._nowPlayingSounds.push(snd);
            snd.volume = $volume;
            if(!randomStartTime)snd.startTime = $startTime;
            else                snd.startTime = snd.length*Math.random();
            snd.loops = $loops;

            if (snd.paused)
            {
                getInstance()._soundsDict[snd.name].channel = snd.sound.play(snd.position, snd.loops, new SoundTransform(snd.volume));
            }
            else
            {
                getInstance()._soundsDict[snd.name].channel = snd.sound.play($startTime, snd.loops, new SoundTransform(snd.volume));
            }

            snd.paused = false;
        }

        /**
         * Stops the specified sound.
         *
         * @param $name The string identifier of the sound
         *
         * @return void
         */
        public static function stopSound($name:String):void
        {
            var snd:CustomSound = getInstance()._soundsDict[$name];
            snd.paused = true;
//            fadeSound(snd.name, 0, 0.1);
//            getInstance()._soundsDict[snd.name].channel.stop();
            snd.channel.stop();
//            snd.position = snd.channel.position;
        }

        /**
         * Pauses the specified sound.
         *
         * @param $name The string identifier of the sound
         *
         * @return void
         */
        public function pauseSound($name:String):void
        {
            var snd:CustomSound = this._soundsDict[$name];
            snd.paused = true;
//            snd.position = snd.channel.position;
//            snd.channel.stop();
        }

        /**
         * Plays all the sounds that are in the sound dictionary.
         *
         * @param $useCurrentlyPlayingOnly A boolean that only plays the sounds which were currently playing before a pauseAllSounds() or stopAllSounds() call (default: false)
         *
         * @return void
        /* *//*
        public function playAllSounds($useCurrentlyPlayingOnly:Boolean = false):void
        {
            for (var i:int = 0; i <this._sounds.length; i++)
            {
                var id:String = this._sounds[i].name;

                if ($useCurrentlyPlayingOnly)
                {
                    if (this._soundsDict[id].pausedByAll)
                    {
                        this._soundsDict[id].pausedByAll = false;
                        this.playSound(id);
                    }
                }
                else
                {
                    this.playSound(id);
                }
            }
        }*/

        /**
         * Stops all the sounds that are in the sound dictionary.
         *
         * @param $useCurrentlyPlayingOnly A boolean that only stops the sounds which are currently playing (default: true)
         *
         * @return void
         */
        public static function stopAllSounds($useCurrentlyPlayingOnly:Boolean = true):void
        {
            getInstance()._masterChannel.stop();
            for (var i:int = 0; i < getInstance()._sounds.length; i++)
            {
                var id:String =  getInstance()._sounds[i].name;

                if ($useCurrentlyPlayingOnly)
                {
                    if (! getInstance()._soundsDict[id].paused)
                    {
                        getInstance()._soundsDict[id].pausedByAll = true;
                        stopSound(id);
                    }
                }
                else
                {
                    stopSound(id);
                }
            }
        }

        /**
         * Pauses all the sounds that are in the sound dictionary.
         *
         * @param $useCurrentlyPlayingOnly A boolean that only pauses the sounds which are currently playing (default: true)
         *
         * @return void
         */
        public function pauseAllSounds($useCurrentlyPlayingOnly:Boolean = true):void
        {
            for (var i:int = 0; i <this._sounds.length; i++)
            {
                var id:String = this._sounds[i].name;

                if ($useCurrentlyPlayingOnly)
                {
                    if (!this._soundsDict[id].paused)
                    {
                        this._soundsDict[id].pausedByAll = true;
                        this.pauseSound(id);
                    }
                }
                else
                {
                    this.pauseSound(id);
                }
            }
        }

        /**
         * Fades the sound to the specified volume over the specified amount of time.
         *
         * @param $name The string identifier of the sound
         * @param $targVolume The target volume to fade to, between 0 and 1 (default: 0)
         * @param $fadeLength The time to fade over, in seconds (default: 1)
         *
         * @return void
         */
        public static function fadeSound($name:String, $targVolume:Number = 0, $fadeLength:Number = 1):void
        {
            var fadeChannel:SoundChannel = getInstance()._soundsDict[$name].channel;

            if(fadeChannel) TweenLite.to(fadeChannel, $fadeLength, {volume: $targVolume});
        }

        /**
         * Mutes the volume for all sounds in the sound dictionary.
         *
         * @return void
         */
        public function muteAllSounds():void
        {
            for (var i:int = 0; i <this._sounds.length; i++)
            {
                var id:String = this._sounds[i].name;

                this.setSoundVolume(id, 0);
            }
        }

        /**
         * Resets the volume to their original setting for all sounds in the sound dictionary.
         *
         * @return void
         */
        public function unmuteAllSounds():void
        {
            for (var i:int = 0; i <this._sounds.length; i++)
            {
                var id:String = this._sounds[i].name;
                var snd:CustomSound = this._soundsDict[id];
//                var curTransform:SoundTransform = snd.channel.soundTransform;
//                curTransform.volume = snd.volume;
//                snd.channel.soundTransform = curTransform;
            }
        }

        /**
         * Sets the volume of the specified sound.
         *
         * @param $name The string identifier of the sound
         * @param $volume The volume, between 0 and 1, to set the sound to
         *
         * @return void
         */
        public function setSoundVolume($name:String, $volume:Number):void
        {
            var snd:CustomSound = this._soundsDict[$name];
//            var curTransform:SoundTransform = snd.channel.soundTransform;
//            curTransform.volume = $volume;
//            snd.channel.soundTransform = curTransform;
        }

        /**
         * Gets the volume of the specified sound.
         *
         * @param $name The string identifier of the sound
         *
         * @return Number The current volume of the sound
         */
        public function getSoundVolume($name:String):Number
        {
            return this._soundsDict[$name].channel.soundTransform.volume;
        }

        /**
         * Gets the position of the specified sound.
         *
         * @param $name The string identifier of the sound
         *
         * @return Number The current position of the sound, in milliseconds
         */
        public function getSoundPosition($name:String):Number
        {
            return this._soundsDict[$name].channel.position;
        }

        /**
         * Gets the duration of the specified sound.
         *
         * @param $name The string identifier of the sound
         *
         * @return Number The length of the sound, in milliseconds
         */
        public function getSoundDuration($name:String):Number
        {
            return this._soundsDict[$name].sound.length;
        }

        /**
         * Gets the sound object of the specified sound.
         *
         * @param $name The string identifier of the sound
         *
         * @return Sound The sound object
         */
        public function getSoundObject($name:String):Sound
        {
            return this._soundsDict[$name].sound;
        }

        /**
         * Identifies if the sound is paused or not.
         *
         * @param $name The string identifier of the sound
         *
         * @return Boolean The boolean value of paused or not paused
         */
        public function isSoundPaused($name:String):Boolean
        {
            return this._soundsDict[$name].paused;
        }

        /**
         * Identifies if the sound was paused or stopped by calling the stopAllSounds() or pauseAllSounds() methods.
         *
         * @param $name The string identifier of the sound
         *
         * @return Number The boolean value of pausedByAll or not pausedByAll
         */
        public function isSoundPausedByAll($name:String):Boolean
        {
            return this._soundsDict[$name].pausedByAll;
        }

        //- EVENT HANDLERS ----------------------------------------------------------------------------------------



        //- GETTERS & SETTERS -------------------------------------------------------------------------------------

        public function get sounds():Vector.<CustomSound>
        {
            return this._sounds;
        }

	    public static function get isPlayingMusic():Boolean {return getInstance()._isPlayingMusic;}
	    public static function setPlayingMusic(value:Boolean):Boolean
	    {
		    getInstance()._isPlayingMusic = value;
		    return _instance._isPlayingMusic;
	    }

	    public static function get isPlayingSounds():Boolean {return getInstance()._isPlayingSounds;}
	    public static function setPlayingSounds(value:Boolean):Boolean
	    {
		    if (value)
		        getInstance().unmuteAllSounds();
		    else
		        getInstance().muteAllSounds();

		    getInstance()._isPlayingSounds = value;
		    return _instance._isPlayingSounds;
	    }

        //- HELPERS -----------------------------------------------------------------------------------------------

        public function toString():String
        {
            return getQualifiedClassName(this);
        }

        //- END CLASS ---------------------------------------------------------------------------------------------
    }



}
