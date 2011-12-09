package view.renderers
{
	import com.greensock.events.LoaderEvent;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import lui.LUIWidget;
	
	import model.items.Plant;
	
	import resources.ImageResource;

	public class PlantRenderer extends LUIWidget
	{
		private var _imageResource:ImageResource;
		private var _data:Object;
		private var _iconPlant:Bitmap;
		private var _iconContainer:Sprite = new Sprite();
		private var _level:int;
		
		public function PlantRenderer()
		{
			addChild(_iconContainer);
		}
		
		public function set data(value:Object):void
		{
			if (_data == value)
			{	
				return;	
			}
			_data = value;
			_level = (_data as Plant).level;
			_imageResource = new ImageResource((_data as Plant).type + String(_level));
			_imageResource.setListeners(onComplete);
		}
		
		public function get data():Object
		{
			return _data;
		}
		
		private function onComplete(event:LoaderEvent):void
		{
			if (_iconPlant != null && _iconContainer.contains(_iconPlant))
			{
				_iconContainer.removeChild(_iconPlant);
			}
			_iconPlant = _imageResource.bitmap;
			_iconContainer.addChild(_iconPlant);
			resize();
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function update():void
		{
			if (_data != null && _level != (_data as Plant).level)
			{
				_imageResource = new ImageResource((_data as Plant).type + String(_level));
				_imageResource.setListeners(onComplete);
			}
		}		
		
		override public function resize():void
		{
			_width = _iconPlant.width;
			_height = _iconPlant.height;
		}
	}
}