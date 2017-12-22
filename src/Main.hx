package;

import flash.Lib;

import flash.desktop.NativeApplication;
import flash.display.BitmapData;
import flash.geom.Rectangle;
import flash.system.Capabilities;
import flash.text.TextFormat;

import starling.core.Starling;
import starling.display.*;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.text.TextField;
import starling.textures.Texture;

class Main extends Sprite {

	static function main() {
		Lib.current.addChild(new Main());
		
	}
	
	public static var _stage:flash.display.Stage;
	
	//[Embed(source=".../SourceSansPro-Regular.ttf",fontFamily="SourceSansPro",fontWeight="normal",mimeType="application/x-font",embedAsCFF="true")]
	//protected static const SOURCE_SANS_PRO_REGULAR:Class;
	//
	//[Embed(source=".../SourceSansPro-Semibold.ttf",fontFamily="SourceSansPro",fontWeight="bold",mimeType="application/x-font",embedAsCFF="true")]
	//protected static const SOURCE_SANS_PRO_SEMIBOLD:Class;

	public var _starling:Starling;
	public var curPage:Sprite;
	
	public var pink:Int = 0xBD0072;
	public var pinkText:Int = 0xCC0091;
	public var grey:Int = 0xD2D3D4;
	
	public var pageWidth:Int = 440;
	public var curStageW:Int;
	
	public var effect:String = "slide";
	
	public var textScale:Float = 1;
	
	
	public function new() {
		super();
		
		var list:Array<String>;
		var t:String;
		
		/*// init stage
		_Self = this;
		
		addEventListener(Event.ADDED_TO_STAGE, OnStaged);
	}
	private function OnStaged(e:Event) {
		*/
	
		this._stage = this.stage;
		_stage.align = "TL";
		_stage.scaleMode = "noScale";
		
		Sys.init(_stage);
		Tween.init(_stage);
		
		_stage.frameRate = 60;
		
		Starling.multitouchEnabled = true; // useful on mobile devices
		
		_stage.addEventListener(Event.RESIZE, OnResized);
		
		_starling = new Starling(Sprite, _stage);
		_starling.addEventListener(starling.events.Event.ROOT_CREATED, OnStarlingInit);
		_starling.enableErrorChecking = Capabilities.isDebugger;
		_starling.start();
		
		if (Sys.isMobile) {
			
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, OnACTIVATE);
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, OnDEACTIVATE);
		
		}
	}
	
	private function OnACTIVATE(e:Dynamic) {
		_starling.start();
	}
	private function OnDEACTIVATE(e:Dynamic) {
		_starling.stop(true);
	}
	private function OnResized(e:Dynamic) {
		
		if (_starling) {
			
			// resize starling to match screen size
			var w:Int = _stage.stageWidth;
			var h:Int = _stage.stageHeight;
			_starling.viewPort = new Rectangle(0, 0, w, h);
			_starling.stage.stageWidth = w;
			_starling.stage.stageHeight = h;
			curStageW = w;
			
			// resize holder by width to match screen size
			ResizePage();
			
		}
		
	}
	private function OnStarlingInit(e:starling.events.Event) {
		
		OnResized(null);
		
		ShowNextPage();
		
		//StarlingDebugger.Start(_stage, _starling.stage);
		
	}
	private function ShowNextPage() {
		
		var nextPage:Sprite = RenderPage();
		
		var renderTime:Float = 0;
		
		if (effect == "slide"){
			
			// next page in
			nextPage.x = curStageW;
			Tween.Start(nextPage, 0.15, { x: 0, delay:renderTime }, easeType.QuadInOut );
			
			// cur page out
			Tween.Start(curPage, 0.15, { x: -curStageW, delay:renderTime, onCompleteDestroy:true }, easeType.QuadInOut);
			
		}
		if (effect == "fade"){
			
			// next page in
			nextPage.alpha = 0;
			Tween.Start(nextPage, 0.2, { alpha:1, delay:renderTime }, 0);
			
			// cur page out
			Tween.Start(curPage, 0.2, { onCompleteDestroy:true }, 0);
			
		}
		
		curPage = nextPage;
		
	}
	private function RenderPage():Sprite {
		
		var infos:Array = [
			{name:"Slacker Radio", 		desc:"25.5K downloads", 	rating:3.5,		stats:[3,4,3,2,5]},
			{name:"Spotify", 			desc:"19M downloads", 		rating:4.4,		stats:[4, 5, 4, 4, 5]},
			{name:"MyFitnessPal", 		desc:"200K downloads", 		rating:4.0,		stats:[3, 4, 2, 2, 5]},
			{name:"Runtastic PRO", 		desc:"500M downloads", 		rating:1.5,		stats:[1,3,2,1,2]},
			{name:"Apple Music", 		desc:"2M downloads", 		rating:3.5,		stats:[3,4,3,2,5]},
			{name:"Bandcamp", 			desc:"3.5K downloads", 		rating:4.4,		stats:[4, 5, 4, 4, 5]},
			{name:"DeaDBeef Player",	desc:"2K downloads", 		rating:4.0,		stats:[5, 4, 5, 3, 2]},
			{name:"Pocket Casts", 		desc:"120K downloads", 		rating:2.0,		stats:[3, 1, 2, 1]}
		];
		
		infos = A.Shuffle(infos);
		
		var holder:Sprite = new Sprite(cast(_starling.root, DisplayObjectContainer));
		
		var x:Int = 20;
		var y:Int = 20;
		var w:Int = pageWidth - (x * 2);
		
		// DRAW CARDS
		var cards:Array = [];
		for (info in infos) {
			var card:Sprite = DrawCard(holder, info, x, y, w);
			y += card.height + 10;
			cards.push(card);
		}
		
		// DRAW BACK
		DrawRect(holder, 0, 0, pageWidth, y + 20, grey).swapToBottom();
		
		/*// RENDER NOW SO FX COMES LATER
		_starling.render();
		
		// FADE IN
		var c:Int = 0;
		for each (var card:Sprite in cards) {
			var startX:Float = card.x;
			card.alpha = 0;
			card.x =  startX - 20;
			Tween.Start(card, 0.2, { alpha:1, x:startX, delay:(0.05 * c) + 1 } );
			c++;
		}*/
		
		//StarlingDebugger.Start(_stage, _starling.stage);
		
		holder.scale = (curStageW / pageWidth);
		
		return holder;
	}
	private function ResizePage() {
		
		// resize holder by width to match screen size
		textScale = (curStageW / pageWidth);
		if (curPage) {
			curPage.scale = (curStageW / pageWidth);
		}
	}
	private function OnStarlingTouch(e:TouchEvent) {
		
		// 3 phases : hover, began, ended
		
		var touch:Touch = e.touches[0];
		if (touch.phase == "ended") {
			
			// CLICK EVENT
			
			var h:Sprite = cast(e.target, Sprite);
			
			AnimateCircle(h, touch, 0, 0, 400, 85);
			
		}
	}
	
	
	
	// UTILS
	
	public function DrawCard(parent:Sprite, data:Dynamic, x:Int, y:Int, w:Int):Sprite {
		var h:Sprite = new Sprite();
		parent.addChild(h);
		h.x = x;
		h.y = y;
		
		DrawRect(h, 0, 0, w, 85, 0xFFFFFF);
		
		DrawStats(h, data.stats, 340, 10, 55, 45, pink, 6);
		
		DrawTextImage(h, 110, 10, 200, pinkText, 24, data.name);
		DrawTextImage(h, 110, 45, 200, 0x000000, 15, data.desc, false, true);
		
		h.touchGroup = true;
		h.touchable = true;
		
		h.addEventListener(TouchEvent.TOUCH, OnStarlingTouch);
		
		return h;
	}
	public function DrawStats(parent:Sprite, data:Array<Float>, x:Int, y:Int, w:Int, h:Int, color:Int, barw:Int) {
		var gap:Int = 5;
		var gapw:Int = (w / data.length);
		
		for (s in 0...data.length) {
			var stat:Int = data[s];
			
			var yo:Int = h * (stat / 5);
			var bar:Quad = DrawRect(parent, x, y + (h - yo), barw, yo, color, true);
			
			AnimateScaleUpward(bar, 0.5, easeType.QuadOut);
			
			x += gapw;
		}
	}
	public function DrawRect(parent:Sprite, x:Int, y:Int, w:Int, h:Int, color:Int, centerOnBottom:Bool = false):Quad {
		if (w <= 0 || h <= 0) {
			return null;
		}
		var q:Quad = new Quad(w, h, color, parent);
		q.x = x;
		q.y = y;
		return q;
	}
	public function DrawText(parent:Sprite, x:Int, y:Int, w:Int, color:Int, fontsize:Int, text:String, bold:Bool = false, italic:Bool = false, multiline:Bool = false):TextField {
		if (w <= 0) {
			return null;
		}
		var fmt:TextFormat = new TextFormat("Roboto", fontsize, color, "left", "center", bold, italic);
		var tf:TextField = new TextField(w, fontsize * 2, text, fmt, parent);
		tf.x = x;
		tf.y = y;
		tf.wordWrap = multiline;
		return tf;
	}
	public function DrawTextImage(parent:Sprite, x:Int, y:Int, w:Int, color:Int, fontsize:Int, text:String, bold:Bool = false, italic:Bool = false, multiline:Bool = false):Image {
		if (w <= 0 || text.length == 0) {
			return null;
		}
		
		// NEW TF
		var fmt:TextFormat = new TextFormat("Roboto", fontsize, color, bold, italic, null, null, null, "left");
		var tf:flash.display.TextField = new flash.display.TextField();
		tf.width = w;
		tf.height = fontsize * 2;
		tf.defaultTextFormat = fmt;
		tf.wordWrap = multiline;
		tf.text = text;
		//tf.embedFonts = true;
		
		// NEW BITMAP
		var minW:Int = N.N_Min(tf.width, tf.textWidth + 10);
		var minH:Int = N.N_Min(tf.height, tf.textHeight + 10);
		if (minW <= 0 || minH <= 0){
			return null;
		}
		tf.scaleX = tf.scaleY = textScale;
		var bitmapData:BitmapData = CaptureToBitmap(tf, true, minW * textScale, minH * textScale, true);
		
		// NEW STARTEXTURE
		//skip Texture.fromBitmapData() because we don't want
		//it to create an onRestore function that will be
		//immediately discarded for garbage collection. 
		//var newTexture:Texture = Texture.empty(bitmapData.width, bitmapData.height, true, false, false, 1);
		//newTexture.root.uploadBitmapData(bitmapData);
		var newTexture:Texture = Texture.fromBitmapData(bitmapData, false, false, textScale);
		
		// NEW IMAGE
		var snapshot:Image = new Image(newTexture);
		parent.addChild(snapshot);
		snapshot.x = x;
		snapshot.y = y;
		return snapshot;
	}
	
	public function CaptureToBitmap(mc:flash.display.DisplayObject, transparent:Bool, width:Int, height:Int, antialias:Bool):BitmapData {
		
		// capture given sprite into bitmap
		var bitmap:BitmapData = new BitmapData(width, height, transparent, 0x00FFFFFF);
		bitmap.draw(mc, mc.transform.matrix, mc.transform.colorTransform, null, null, antialias);
		return bitmap;
	}
	
	public function DrawCircle(parent:Sprite, x:Int, y:Int, width:Int, color:Int):Canvas {
		if (width <= 0) {
			return null;
		}
		var q:Canvas = new Canvas();
		parent.addChild(q);
		q.beginFill(color);
		q.drawCircle(x, y, width);
		q.endFill();
		return q;
	}
	
	/** scale an object upward (growing up) */
	public function AnimateScaleUpward(bar:DisplayObject, duration:Float, ease:Int) {
		
		var barY:Int = bar.y;
		var barH:Int = bar.height;
		
		bar.y = barY + barH;
		bar.height = 0;
		
		Tween.Start(bar, duration, {y:barY, height:barH}, ease);
		
	}
	/** draw animated circle like Android Material Design */
	public function AnimateCircle(holder:Sprite, touch:Touch, x:Int, y:Int, w:Int, h:Int) {
		
		// draw animated circle like Android Material Design
		
		var mask:Quad = DrawRect(holder, x, y, w, h, 0x000000);
		var circ:Canvas = DrawCircle(holder, 0, 0, w/2, 0x000000);
		circ.mask = mask;
		
		circ.alpha = 0.2;
		circ.scale = 0;
		
		circ.position = touch.getLocation(holder);
		
		// 2nd last item so below all text content
		circ.swapToBottom();
		circ.swapOneUp();
		
		Tween.Start(circ, 0.2, { scale:1, alpha:0, onCompleteDestroy:true }, 0);
		Tween.Start(mask, 0.3, { onCompleteDestroy:true });
		
		Tween.DoLater(0.2, ShowNextPage);
		
	}
	
}