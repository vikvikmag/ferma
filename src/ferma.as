package
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.XMLLoader;
	
	import flash.display.Sprite;
	import flash.system.Security;
	
	import model.book.ImagesBook;
	import model.book.PlantsBook;
	
	import view.MainStage;
	
	[SWF(width="807", height="700", frameRate="30", backgroundColor="#EEEEBB")]
	public class ferma extends Sprite
	{
		private var _loader:LoaderMax = new LoaderMax({
			name:"mainQueue",
			onProgress:progressHandler, 
			onComplete:completeHandler, 
			onError:errorHandler});
		private var _xml:XML;
		
		public function ferma()
		{
			Security.allowDomain("*");
			LoaderMax.activate([ImageLoader]);
			initData();
		}
		
		private function initData():void
		{
			_loader.append(new XMLLoader("../xml/doc.xml", {name:"xmlDoc"}));
			_loader.load();
		}
		
		public function get xml():XML
		{
			return _xml;
		}
		
		private function progressHandler(event:LoaderEvent):void {
			trace("progress: " + event.target.progress);
		}
		
		private function completeHandler(event:LoaderEvent):void {
			//trace("load complete. XML content: " + LoaderMax.getContent("xmlDoc"));
			
			_xml = LoaderMax.getContent("xmlDoc");
			
			PlantsBook.instance.init(_xml);
			ImagesBook.instance.init(_xml);
			
			//Assuming there was an  node in the XML, get the associated image...
			//var image:ImageLoader = LoaderMax.getLoader("clover1");
			//addChild(image);
			
			initStage();
		}
		
		private function errorHandler(event:LoaderEvent):void {
			trace("error occured with " + event.target + ": " + event.text);
		}
		
		private var _mainStage:MainStage;
		
		private function initStage():void
		{
			_mainStage = new MainStage();
			_mainStage.setSize(807, 700);
			addChild(_mainStage);
		}
	}
}