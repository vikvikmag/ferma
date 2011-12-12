package view
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.text.StaticText;
	import flash.utils.Dictionary;
	
	public class PopupManager
	{
		private static const DEFAULT_POPUP_SPEED:Number = 0.1;
		private static const DEFAULT_FADE_SPEED:Number = 0.2;
		
		private static var _numModals:int = 0;
		
		private static var _initialized:Boolean = false;
		
		private static var _popups:Dictionary;
		
		private static function init():void
		{
			if (_initialized)
			{
				return;
			}
			_initialized = true;
			
			_popups = new Dictionary();			
			_layer = new Sprite();			
		}
		
		public static function addPopUp(popUp:DisplayObject, modal:Boolean = true, 
										position:Point = null):void
		{
			if (!_initialized)
			{
				init();
			}
			
			if (_popups[popUp] != null)
			{
				_layer.addChild(popUp);
				return;
			}
			
			_popups[popUp] = new PopupData(modal, popUp);
			_layer.addChild(popUp);
			
			if (modal)
			{
				_numModals++;				
				if (_numModals == 1)
				{
					setModalBackgroundVisible(true);
				}
			}
			checkPopUpsBlocked();
			checkPosition(popUp, position);
		}
		
		private static function checkPosition(popUp:DisplayObject, position:Point):void
		{
			if (position != null)
			{
				popUp.x = position.x;
				popUp.y = position.y;
				if (popUp.x + popUp.width > _screenWidth)
				{
					popUp.x = _screenWidth - popUp.width - 5;
				}
				if (popUp.x < 0)
				{
					popUp.x = 5;
				}
				if (popUp.y + popUp.height > _screenHeight)
				{
					popUp.y = _screenHeight - popUp.height - 5;
				}
				if (popUp.y < 0)
				{
					popUp.y = 5;
				}
			}
		}
		
		public static function addPopUpAnimated(
			popUp:DisplayObject,
			modal:Boolean = true,
			animSpeed:Number = DEFAULT_POPUP_SPEED
		):void
		{
			addPopUp(popUp, modal);
			
			var popupData:PopupData = (_popups[popUp] as PopupData);
			popupData.animSpeed = animSpeed;
			popupData.animAlpha = 0;
			popupData.animType = 1;
			if (!_layer.hasEventListener(Event.ENTER_FRAME))
			{
				_layer.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
			updatePopupAnimation(popupData);
		}
		
		public static function removePopUpAnimated(
			popUp:DisplayObject,
			animSpeed:Number = DEFAULT_FADE_SPEED
		):void
		{
			if (!_initialized || (_popups[popUp] == null))
			{
				return;
			}
			var popupData:PopupData = (_popups[popUp] as PopupData);
			popupData.animSpeed = animSpeed;			
			popupData.animType = -1;
			if (!_layer.hasEventListener(Event.ENTER_FRAME))
			{
				_layer.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}
		
		public static function removePopUp(popUp:DisplayObject):void
		{
			if (!_initialized || (_popups[popUp] == null))
			{
				return;
			}
			_layer.removeChild(popUp);
			
			if (_popups[popUp].isModal)
			{
				_numModals--;
				if (_numModals <= 0)
				{
					setModalBackgroundVisible(false);
				}				
			}			
			
			delete _popups[popUp];
			checkPopUpsBlocked();
		}
		
		private static function checkPopUpsBlocked():void
		{
			var index:int = _layer.numChildren;
			var modal:Boolean = false;
			for (var i:int = index; i-- > 0;)
			{
				var popUp:DisplayObject = _layer.getChildAt(i);			
				enabledPopUp(popUp, !modal);
				modal ||= Boolean(_popups[popUp].isModal);
			}
		}
		
		private static function enabledPopUp(popUp:DisplayObject, value:Boolean):void
		{
			if (popUp.hasOwnProperty("mouseEnabled"))
			{
				popUp["mouseEnabled"] = value;
			}
			if (popUp.hasOwnProperty("mouseChildren"))
			{
				popUp["mouseChildren"] = value;
			}
			popUp.filters = value ? null : [new ColorMatrixFilter([
				0.4, 0, 0, 0, 0,
				0, 0.4, 0, 0, 0,
				0, 0, 0.4, 0, 0,
				0, 0, 0, 1, 0
			])];
		}
		
		public static function centerPopUp(popUp:DisplayObject):void
		{
			if (!_initialized || (_popups[popUp] == null))
			{
				return;
			}
			
			popUp.x = int(_screenWidth - popUp.width) >> 1;
			popUp.y = int(_screenHeight - popUp.height) >> 1;
		}
		
		/*public static function setPositionPopUp(popUp:DisplayObject):void
		{
			if (!_initialized || (_popups[popUp] == null))
			{
				return;
			}
			
			popUp.x = int(_screenWidth - popUp.width) >> 1;
			popUp.y = int(_screenHeight - popUp.height) >> 1;
		}*/
		
		private static function onEnterFrame(event:Event = null):void
		{
			var needAnimate:Boolean = false;
			var removingPopups:Array = new Array();
			
			for each (var data:PopupData in _popups)
			{
				if (data.animType == 1)
				{
					data.animAlpha = Math.min(1, data.animAlpha + data.animSpeed);
					if (data.animAlpha >= 1)
					{
						data.animType = 0;
					}					
				}
				else if (data.animType == -1)
				{
					data.animAlpha = Math.max(0, data.animAlpha - data.animSpeed);
					if (data.animAlpha <= 0)
					{
						data.animType = 0;			
						removingPopups.push(data.popup);
					}					
				}
				needAnimate = needAnimate || (data.animType != 0);
				updatePopupAnimation(data);
			}			
			
			if (!needAnimate)
			{
				_layer.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
			
			for each (var PopUp:DisplayObject in removingPopups)
			{
				removePopUp(PopUp);
			}
		}
		
		private static function updatePopupAnimation(data:PopupData):void
		{
			var popUp:DisplayObject = data.popup;
			var alpha:Number = Math.sin(data.animAlpha * Math.PI * 0.5);
			popUp.alpha = alpha;
			
			/*var scale:Number = Math.sin((data.animAlpha * .5 + 0.5) * Math.PI * 0.5);			
			popUp.scaleX = popUp.scaleY = scale;*/
		}
		
		public static function slidePopUp(popUp:DisplayObject, xSlide:Number, ySlide:Number, scale:Number = 1.0):void
		{
			if (!_initialized || (_popups[popUp] == null))
			{
				return;
			}
			
			popUp.scaleX = scale;
			popUp.scaleY = scale;
			
			popUp.x = int((_screenWidth - popUp.width*scale)*xSlide);
			popUp.y = int((_screenHeight - popUp.height*scale)*ySlide);
		}
		
		private static var _blurLayer:DisplayObject;
		public static function get blurLayer():DisplayObject
		{
			return _blurLayer;
		}
		public static function set blurLayer(value:DisplayObject):void
		{
			_blurLayer = value;
		}
		
		private static var _modalBackgroundColor:uint = 0xffffff;
		public static function get modalBackgroundColor():uint
		{
			return _modalBackgroundColor;
		}		
		public static function set modalBackgroundColor(value:uint):void
		{
			_modalBackgroundColor = value;
		}
		
		private static var _modalBackgroundAlpha:Number = .4;
		public static function get modalBackgroundAlpha():Number
		{
			return _modalBackgroundAlpha;
		}
		public static function set modalBackgroundAlpha(value:Number):void
		{
			_modalBackgroundAlpha = value;
		}
		
		private static var _layer:Sprite;
		public static function get layer():Sprite
		{
			if (!_initialized)
			{
				init();
			}
			return _layer;
		}
		
		private static var _modalBackgroundVisible:Boolean = false;
		private static function setModalBackgroundVisible(value:Boolean):void
		{
			if (_modalBackgroundVisible == value)
			{
				return;
			}
			_modalBackgroundVisible = value;
			
			redrawBG();
			if (_blurLayer != null)
			{
				_blurLayer.filters = _modalBackgroundVisible ?
					getBlurFilters() :
					null;
			}
		}
		
		private static var _blurFilters:Array; 
		
		private static function getBlurFilters():Array
		{
			if (_blurFilters == null)
			{
				_blurFilters = [new BlurFilter()];
			}
			return _blurFilters;
		}
		
		private static function redrawBG():void
		{
			var g:Graphics = _layer.graphics;
			g.clear();
			if (_modalBackgroundVisible)
			{
				g.beginFill(_modalBackgroundColor, _modalBackgroundAlpha);
				g.drawRect(0, 0, _screenWidth, _screenHeight);
				g.endFill();
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Размеры экрана
		//
		//--------------------------------------------------------------------------
		
		private static var _screenWidth:int = 607;
		public static function get screenWidth():int
		{
			return _screenWidth;
		}
		
		private static var _screenHeight:int = 590;
		public static function get screenHeight():int
		{
			return _screenHeight;
		}
		
		public static function setScreenSize(width:int, height:int):void
		{
			_screenWidth = width;
			_screenHeight = height;
			redrawBG();
		}
	}
}
import flash.display.DisplayObject;

internal class PopupData
{	
	public var animAlpha:Number;
	public var animSpeed:Number;
	public var animType:int;
	public var isModal:Boolean;
	public var popup:DisplayObject;
	
	public function PopupData(modal:Boolean, popup:DisplayObject)
	{
		this.animAlpha = 0;		
		this.animType = 0;
		this.isModal = modal;
		this.animSpeed = animSpeed;
		this.popup = popup;
	}
}