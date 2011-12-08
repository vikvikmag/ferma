package view.renderers
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.display.ContentDisplay;
	
	import flash.display.DisplayObject;
	
	import lui.LUIWidget;

	public class CountryRenderer extends LUIWidget
	{
		private var _imageLoader:ImageLoader;
		private var _bg:ContentDisplay;
		
		public function CountryRenderer()
		{
			_imageLoader = LoaderMax.getLoader("BG");
			_imageLoader.addEventListener(LoaderEvent.COMPLETE, onComplete);
			_imageLoader.addEventListener(LoaderEvent.ERROR, onError);
			_imageLoader.addEventListener(LoaderEvent.PROGRESS, onProgress);
			_imageLoader.load();
		}
		
		private function onComplete(event:LoaderEvent):void
		{
			_imageLoader.removeEventListener(LoaderEvent.COMPLETE, onComplete);
			_imageLoader.removeEventListener(LoaderEvent.ERROR, onError);
			_imageLoader.removeEventListener(LoaderEvent.PROGRESS, onProgress);
			_bg = _imageLoader.content;
			
			addChild(_bg);
			
			resize();
		}
		
		private function onProgress(event:LoaderEvent):void
		{
			trace("CountryRenderer: ",_imageLoader.bytesLoaded, "/", _imageLoader.bytesTotal);
		}
		
		private function onError(event:LoaderEvent):void
		{
			trace("BG поля не загрузилось");
		}
		
		override public function resize():void
		{
			//_width = _bg.
		}
	}
}