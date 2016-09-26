package
{
	public class AStar
	{
		private var _open:Vector.<Node>;
		private var _closed:Vector.<Node>;
		private var _grid:Grid;
		private var _endNode:Node;
		private var _startNode:Node;
		private var _path:Vector.<Node>;
		private var _heuristic:Function = manhattan;
//		private var _heuristic:Function = euclidian;
//      private var _heuristic:Function = diagonal;
		private var _straightCost:int = 10;
		private var _diagCost:int = 14;
		
		
		public function AStar()
		{
		}
		
		public function findPath(grid:Grid):Boolean
		{
			_grid = grid;
			_open = new Vector.<Node>();
			_closed = new Vector.<Node>();
			
			_startNode = _grid.startNode;
			_endNode = _grid.endNode;
			
			_startNode.g = 0;
			_startNode.h = _heuristic(_startNode);
			_startNode.f = _startNode.g + _startNode.h;
			
			return search();
		}
		
		public function search():Boolean
		{
			var node:Node = _startNode;
			while(node != _endNode)
			{
				var startX:int = Math.max(0, node.x - 1);
				var endX:int = Math.min(_grid.numCols - 1, node.x + 1);
				var startY:int = Math.max(0, node.y - 1);
				var endY:int = Math.min(_grid.numRows - 1, node.y + 1);
				
				for(var i:int = startX; i <= endX; i++)
				{
					for(var j:int = startY; j <= endY; j++)
					{
						var test:Node = _grid.getNode(i, j);
						if(test == node || 
						   !test.walkable ||
						   !_grid.getNode(node.x, test.y).walkable ||
						   !_grid.getNode(test.x, node.y).walkable)
						{
							continue;
						}
						
						var cost:int = _straightCost;
						if(!((node.x == test.x) || (node.y == test.y)))
						{
							cost = _diagCost;
						}
						var g:int = node.g + cost * test.costMultiplier;
						var h:int = _heuristic(test);
						var f:int = g + h;
						if(isOpen(test) || isClosed(test))
						{
							if(test.f > f)
							{
								test.f = f;
								test.g = g;
								test.h = h;
								test.parent = node;
							}
						}
						else
						{
							test.f = f;
							test.g = g;
							test.h = h;
							test.parent = node;
							_open.push(test);
						}
					}
				}
				_closed.push(node);
				if(_open.length == 0)
				{
					//trace("no path found");
					return false
				}
				_open.sort(myCmp);
				node = _open.shift() as Node;
			}
			buildPath();
			return true;
		}
		
		private function myCmp(na:Node,nb:Node):Number
		{
			if(na.f < nb.f) return -1;
			if(na.f == nb.f) return 0;
			return 1;
		}
		
		private function buildPath():void
		{
			_path = new Vector.<Node>();
			var node:Node = _endNode;
			_path.push(node);
			while(node != _startNode)
			{
				node = node.parent;
				_path.unshift(node);
			}
		}
		
		public function get path():Vector.<Node>
		{
			return _path;
		}
		
		private function isOpen(node:Node):Boolean
		{
			for(var i:int = 0; i < _open.length; i++)
			{
				if(_open[i] == node)
				{
					return true;
				}
			}
			return false;
		}
		
		private function isClosed(node:Node):Boolean
		{
			for(var i:int = 0; i < _closed.length; i++)
			{
				if(_closed[i] == node)
				{
					return true;
				}
			}
			return false;
		}
		
		private function manhattan(node:Node):Number
		{
			return Math.abs(node.x - _endNode.x) * _straightCost + Math.abs(node.y + _endNode.y) * _straightCost;
		}
		
		private function euclidian(node:Node):Number
		{
			var dx:Number = node.x - _endNode.x;
			var dy:Number = node.y - _endNode.y;
			return Math.sqrt(dx * dx + dy * dy) * _straightCost;
		}
		
		private function diagonal(node:Node):int
		{
			var dx:int = Math.abs(node.x - _endNode.x);
			var dy:int = Math.abs(node.y - _endNode.y);
			var diag:int = Math.min(dx, dy);
			var straight:int = dx + dy;
			return _diagCost * diag + _straightCost * (straight - 2 * diag);
		}
		
		public function get visited():Vector.<Node>
		{
			return _closed.concat(_open);
		}
	}
}
