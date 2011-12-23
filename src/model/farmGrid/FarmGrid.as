package model.farmGrid
{
	import controller.GameController;
	
	import model.UserData;
	import model.event.UserDataEvent;
	import model.items.Plant;

	public class FarmGrid
	{
		public static const CELL_SIZE:int = 50;
		public static const COUNT_ROWS:int = 13;
		public static const COUNT_COLS:int = 13;
		
		private var _userData:UserData;
		private var _pathGrid:Grid;
		
		private var _path:Array;
		private var _astar:AStar;
				
		public function FarmGrid(userData:UserData)
		{
			_userData = userData;
			makeGrid();
		}
		
		private function makeGrid():void
		{
			_pathGrid = new Grid(COUNT_COLS, COUNT_ROWS);
			for each (var plant:Plant in _userData.plants)
			{
				_pathGrid.setWalkable(plant.tileX, plant.tileY, false);
			}			
		}
		
		/**
		 * 	Находит путь между двумя точками, возвращает массив 
		 * 	точек через которые должен пройти объект
		 */ 
		public function findPath(startX:int, startY:int, endX:int, endY:int):Array
		{
			_pathGrid.setStartNode(startX, startY);
			_pathGrid.setEndNode(endX, endY);
			
			_astar = new AStar();
			if(_astar.findPath(_pathGrid))
			{
				_path = _astar.path;
				return _path;
			}
			return null;			
		}
		
		/**
		 * 	Обновить поле с грядками
		 */ 
		public function update():void
		{
			makeGrid();
		}
	}
}