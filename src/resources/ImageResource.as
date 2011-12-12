package resources
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	public class ImageResource
	{
		private var _imageLoader:ImageLoader;
		private var _type:String;
		private var _onComplete:Function;
		private var _onError:Function;
		private var _onProgress:Function;	
		private var _bitmap:Bitmap;
		private var _bitmapData:BitmapData;		
		
		public function ImageResource(type:String)
		{
			_type = type;
			_imageLoader = LoaderMax.getLoader(type);
			_imageLoader.addEventListener(LoaderEvent.COMPLETE, onComplete);
			_imageLoader.addEventListener(LoaderEvent.ERROR, onError);
			_imageLoader.addEventListener(LoaderEvent.PROGRESS, onProgress);			
		}
		
		public function load():void
		{
			_imageLoader.load();
		}
		
		/**
		 * 	Можно установить обработчики событий
		 */ 
		public function setListeners(onCompleteN:Function, onErrorN:Function = null, 
									 onProgressN:Function = null):void
		{
			_onComplete = onCompleteN;
			_onError = onErrorN;
			_onProgress = onProgressN;
			if (!_imageLoader.hasEventListener(LoaderEvent.COMPLETE))
			{
				_imageLoader.addEventListener(LoaderEvent.COMPLETE, onComplete);
			}
			if (!_imageLoader.hasEventListener(LoaderEvent.ERROR))
			{
				_imageLoader.addEventListener(LoaderEvent.ERROR, onError);
			}
			if (!_imageLoader.hasEventListener(LoaderEvent.PROGRESS))
			{
				_imageLoader.addEventListener(LoaderEvent.PROGRESS, onProgress);
			}
		}
		
		/**
		 * 	Возвращает НОВЫЙ объект Bitmap 
		 */ 
		public function get bitmap():Bitmap
		{			
			return new Bitmap(_bitmapData);
		}	
		
		private function onComplete(event:LoaderEvent):void
		{
			_imageLoader.removeEventListener(LoaderEvent.COMPLETE, onComplete);
			_imageLoader.removeEventListener(LoaderEvent.ERROR, onError);
			_imageLoader.removeEventListener(LoaderEvent.PROGRESS, onProgress);
			
			_bitmap = _imageLoader.rawContent;
			_bitmapData = _bitmap.bitmapData;
			
			if (_onComplete != null)
			{
				_onComplete.call(null, event);
			}
		}
		
		private function onProgress(event:LoaderEvent):void
		{
			if (_onProgress != null)
			{
				_onProgress.call(null, event);
			}
		}
		
		private function onError(event:LoaderEvent):void
		{
			trace(_type, "не загрузилось");
			if (_onError != null)
			{
				_onError.call(null, event);
			}
		}
	}
}