package view.renderers
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.display.ContentDisplay;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import lui.LUIWidget;
	
	import resources.ImageResource;

	public class CountryRenderer extends LUIWidget
	{
		private var _imageResource:ImageResource;
		private var _bg:Bitmap;
		private var _container:Sprite = new Sprite();
		
		public function CountryRenderer()
		{
			_container.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			_container.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_container.addEventListener(MouseEvent.ROLL_OUT, onMouseUp);
			
			addChild(_container);
			_imageResource = new ImageResource("BG");
			_imageResource.setListeners(onComplete, onError, onProgress);			
		}
		
		private function onMouseDown(event:MouseEvent):void
		{
			_container.startDrag();
		}
		
		private function onMouseUp(event:MouseEvent):void
		{
			_container.stopDrag();
		}
		
		private function onComplete(event:LoaderEvent):void
		{
			_bg = _imageResource.bitmap;
			_container.addChild(_bg);
			resize();
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function onProgress(event:LoaderEvent):void
		{
			//trace("CountryRenderer: ", event.target.bytesLoaded, "/", event.target.bytesTotal);
		}
		
		private function onError(event:LoaderEvent):void
		{
		}
		
		override public function resize():void
		{
			_width = _bg.width;
			_height = _bg.height;
		}
	}
}