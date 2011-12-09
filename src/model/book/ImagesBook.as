package model.book
{
	import flash.utils.Dictionary;
	
	import model.items.ImageProperty;

	public class ImagesBook
	{
		private static var _instance:ImagesBook;
		public static function get instance():ImagesBook
		{
			return _instance ||= new ImagesBook();
		}
		
		private const _imagePropertes:Dictionary = new Dictionary();
		
		public function ImagesBook()
		{
		}
		
		public function init(xml:XML):void
		{
			for each(var node:XML in xml.LoaderMax.ImageLoader)
			{
				var image:ImageProperty = new ImageProperty();
				image.name = node.@name;
				image.url = node.@url;
				image.cx = node.@cx;
				image.cy = node.@cy;
				_imagePropertes[image.name] = image;
			}
		}
		
		public function getImagePropertyByName(name:String):ImageProperty
		{
			return _imagePropertes[name];
		}
	}
}