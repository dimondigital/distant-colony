package
{
/**
 * FusionLock by UnknownGuardian.  January 8th 2011.
 * Visit http://profusiongames.com/ and http://github.com/UnknownGuardian
 *
 * Copyright (c) 2010 ProfusionGames
 *    All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * ^ Attribution will be given to:
 *  	- UnknownGuardian http://www.kongregate.com/accounts/UnknownGuardian
 * 		- Based of a Sitelock: fast&dirty domain lock in as3
 * 		by dx0ne http://dx0ne.laislacorporation.com
 * 		http://www.flashrights.com/domaincontrol.htm
 *
 * ^ Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer in all copies or
 * substantial portions of the Software.
 *
 * ^ Redistributions of source code may not add to, subtract from, or in
 * any other way modify the above copyright notice, this list of conditions,
 * or the following disclaimer for any reason.
 *
 * ^ Redistributions in binary form must reproduce the above copyright
 * notice, this list of conditions and the following disclaimer in the
 * documentation and/or other materials provided with the distribution.
 *
 * THE SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
 * IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
 * NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
 * PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
 * OR COPYRIGHT HOLDERS OR CONTRIBUTORS  BE LIABLE FOR ANY CLAIM, DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * OR OTHER LIABILITY,(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
 * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER AN ACTION OF IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING FROM, OUT OF, IN CONNECTION OR
 * IN ANY OTHER WAY OUT OF THE USE OF OR OTHER DEALINGS WITH THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 *
 *
 *
 *
 *
 * English: Use, distribute, etc to this with keeping credits and copyright
 */

import flash.display.Stage;
import flash.net.navigateToURL;
import flash.net.URLRequest;

public class FusionLock
{
    private static var stage:Stage;

    private static var allowLocal:Boolean = false;
    private static var acceptedSites:Array = [];
    private static var deniedSites:Array = [];

    private static var protocol:String = "";
    private static var domain:String = "";

    private static var redirectURL:String = "http://profusiongames.com";

    /**
     * Register the stage for SiteLock
     * @param	_stage The stage of the swf.
     * @return  void
     */
    public static function registerStage(_stage:Stage):void
    {
        stage = _stage;
        trace("[SiteLock] Stage registered");
    }

    /**
     * Sets a list of allowed sites
     * @param	sitesArray  Array of strings of the url. Use base URL, like google.com, yahoo.com.
     * @return  void
     */
    public static function allowSites(sitesArray:Array):void
    {
        acceptedSites = sitesArray.concat();
        trace("[SiteLock] Accepted sites: " + acceptedSites);
    }

    /**
     * Sets a list of denied sites
     * @param	sitesArray  Array of strings of the url. Use base URL, like google.com, yahoo.com.
     * @return  void
     */
    public static function denySites(sitesArray:Array):void
    {
        deniedSites = sitesArray.concat();
        trace("[SiteLock] Denied sites: " + deniedSites);
    }

    /**
     * Sets local testing restrictions
     * @return  void
     */
    public static function allowLocalPlay(permission:Boolean = true ):void
    {
        allowLocal = permission
    }

    /**
     * Checks the URL of the swf and destroys the swf if necessary
     * @return  Boolean Returns true if the swf is hosted on an approved location
     */
    public static function checkURL():Boolean
    {
        //get url
        var url:String = stage.loaderInfo.url;
        //remove http, https, file, etc
        var urlStart:Number = url.indexOf("://") + 3;
        //find first slash after the .com/, .net/, etc
        var urlEnd:Number = url.indexOf("/", urlStart);
        //get the domain name, eg: www.yahoo.com, subdomain.example.com, sub.subdomain.example.com
        domain = url.substring(urlStart, urlEnd);
        //find last dot, so it is not included
        var LastDot:Number = domain.lastIndexOf(".") - 1;
        //find the end of the subdomains by finding last dot from the end
        var domEnd:Number = domain.lastIndexOf(".", LastDot) + 1;
        //get the real domain name
        domain = domain.substring(domEnd, domain.length);
        //get the protocol, like if its a file hosted locally
        protocol = url.substring(0, url.indexOf(":"));
        //debug
        trace("[SiteLock] " + ((protocol == "file")?"The .swf is locally hosted.": "This .swf is hosted at " + domain));
        // if not located on the accepted sites list and its not a file				                                       OR         if its a file and do not allow local playing     OR
        if ((acceptedSites.length != 0 && acceptedSites.indexOf(domain) == -1  && protocol != "file")    ||          (protocol == "file" && !allowLocal)    ||     (deniedSites.length != 0 && deniedSites.indexOf(domain) != -1  && protocol != "file"))
        {
            trace("[SiteLock] This .swf is hosted illegally");
            navigateToURL(new URLRequest(redirectURL), '_blank');
            return false;
        }
        else
        {
            return true;
        }
    }


    /**
     * Checks the URL of the swf and returns true if hosted locally
     * @return  Boolean Returns true if the swf is hosted locally
     */
    public static function isLocal():Boolean
    {
        if (protocol == "")
        {
            //get url
            var url:String = stage.loaderInfo.url;
            //remove http and
            var urlStart:Number = url.indexOf("://") + 3;
            //find first slash after the .com/.net/.etc
            var urlEnd:Number = url.indexOf("/", urlStart);
            //get the domain name, eg: www.yahoo.com or www.google.com
            domain = url.substring(urlStart, urlEnd);
            //strip subdomains, etc
            var LastDot:Number = domain.lastIndexOf(".") - 1;
            //remove the subdomains if located on any
            var domEnd:Number = domain.lastIndexOf(".", LastDot) + 1;
            //get the real domain name
            domain = domain.substring(domEnd, domain.length);
            //get the protocol, like if its a file hosted locally
            protocol = url.substring(0, url.indexOf(":"));
        }
        return protocol == "file";
    }

    /**
     * Gets the domain
     * @return  String Returns the domain the .swf is hosted on
     */
    public static function getDomain():String
    {
        if (domain == "")
        {
            //get url
            var url:String = stage.loaderInfo.url;
            //remove http and
            var urlStart:Number = url.indexOf("://") + 3;
            //find first slash after the .com/.net/.etc
            var urlEnd:Number = url.indexOf("/", urlStart);
            //get the domain name, eg: www.yahoo.com or www.google.com
            domain = url.substring(urlStart, urlEnd);
            //strip subdomains, etc
            var LastDot:Number = domain.lastIndexOf(".") - 1;
            //remove the subdomains if located on any
            var domEnd:Number = domain.lastIndexOf(".", LastDot) + 1;
            //get the real domain name
            domain = domain.substring(domEnd, domain.length);
            //get the protocol, like if its a file hosted locally
            protocol = url.substring(0, url.indexOf(":"));
        }
        return domain;
    }
}
}
