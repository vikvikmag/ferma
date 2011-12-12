package
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.XMLLoader;
	
	import controller.GameController;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.Security;
	
	import model.book.ImagesBook;
	import model.book.PlantsBook;
	
	import myLib.ui.STAGE;
	
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
			//http://vikvikmag.narod2.ru
			_loader.append(new XMLLoader("http://vikvikmag.hut2.ru/xml/doc.xml", {name:"xmlDoc"}));
			_loader.append(new XMLLoader("http://vikvikmag.hut2.ru/xml/userData.xml", {name:"xmlUserData"}));
			_loader.load();
		}
		
		public function get xml():XML
		{
			return _xml;
		}
		
		private function progressHandler(event:LoaderEvent):void 
		{
			trace("progress: " + event.target.progress);
		}
		
		private function completeHandler(event:LoaderEvent):void 
		{
			_xml = LoaderMax.getContent("xmlDoc");
			
			PlantsBook.instance.init(_xml);
			ImagesBook.instance.init(_xml);			
			
			initStage();
			
			GameController.instance.parseUserData(LoaderMax.getContent("xmlUserData"));
		}
		
		private function errorHandler(event:LoaderEvent):void 
		{
			trace("error occured with " + event.target + ": " + event.text);
		}
		
		private var _mainStage:MainStage;
		
		private function initStage():void
		{
			_mainStage = new MainStage();			
			addChild(_mainStage);
			if (stage == null)
			{
				addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			}
			else
			{
				onAddedToStage();
			}
		}
		
		private function onAddedToStage(event:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			_mainStage.setSize(stage.stageWidth, stage.stageHeight);
		}
	}
}