package chacon.git
{
	import chacon.git.*;
	import chacon.utils.ByteArrayPack;
	import flash.utils.ByteArray;
	
	public class AsGitCommit extends AsGitObject
	{
		public var tree:String;
		public var parents:Array;
		
		public var author_string:String;
		public var committer_string:String;
		public var message:String;

		public var author:AsGitAuthor;
		public var committer:AsGitAuthor;
		
		public function AsGitCommit(shaStr:String, body:String, sizeStr:String) {
			sha = shaStr;
			raw = body;
			size = sizeStr;
			message = '';
			parents = new Array();
			processRaw();	
		}	
		
		private function processRaw():void {
			var arr:Array = raw.split("\n");
			var values:Array;
			
			for(var i:int = 0; i < arr.length; i++) {
				trace(arr[i]);
				values = arr[i].match(/(.*?) (.*)/);
				if(values) {
					if(values[1] == 'tree') {
						tree = values[2];
					} else if(values[1] == 'parent') {
						parents.push(values[2]);
					} else if(values[1] == 'author') {
						author_string = values[2]; 
						author = new AsGitAuthor(author_string);
					} else if(values[1] == 'committer') {
						committer_string = values[2];
						committer = new AsGitAuthor(committer_string);
					} else {
						if(arr[i]) {
							message += arr[i];
						}					
					}
				}
			}
		}
	}
		
}