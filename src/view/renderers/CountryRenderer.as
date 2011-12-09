package view.renderers
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.display.ContentDisplay;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	
	import lui.LUIWidget;
	
	import resources.Image;

	public class CountryRenderer extends LUIWidget
	{
		private var _image:Image;
		private var _clover:Image;
		private var _bg:Bitmap;
		
		private var countLoader:int = 0;
		
		public function CountryRenderer()
		{
			_image = new Image("BG");
			_image.setListeners(onComplete, onError, onProgress);
			_clover = new Image("clover1");
			_clover.setListeners(onComplete, onError, onProgress);
		}
		
		private function onComplete(event:LoaderEvent):void
		{
			_bg = _image.bitmap;
			countLoader++;
			if (countLoader >= 2)
			{
				addChild(_bg);
				
				resize();
			}			
		}
		
		private function onProgress(event:LoaderEvent):void
		{
			trace("CountryRenderer: ", event.target.bytesLoaded, "/", event.target.bytesTotal);
		}
		
		private function onError(event:LoaderEvent):void
		{
		}
		
		override public function resize():void
		{
		}
	}
}