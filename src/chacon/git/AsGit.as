package chacon.git
{
	import chacon.utils.ByteArrayPack;
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.filesystem.FileMode;
	import flash.utils.ByteArray;
	
	public class AsGit
	{
		private var gitDirectory:String;
		
		public function AsGit(gitRepoDirectory:String)
		{
			gitDirectory = gitRepoDirectory + '/.git'
		}
		
		public function readObject(sha:String):String {
			sha = sha.substr(0, 40);
			var dir:String = sha.substr(0,2);
			var fname:String = sha.substr(2);
			trace('objects/' + dir + '/' + fname);
			var commit:ByteArray = readObjectBytes('objects/' + dir + '/' + fname);
			commit.uncompress();
			
			var header:ByteArray = new ByteArray();
			var body:ByteArray = new ByteArray();
			
			// read object data
			var in_header:Boolean = true;
			var byte:uint;
			for(var i:uint = 0; i <= commit.length; i++) {
				byte = commit[i];
				if(byte == 0) { // null byte, end of header
					in_header = false
				} else {
					if(in_header) {
						header.writeByte(byte);
					} else {
						body.writeByte(byte);
					}
				}
			}
			trace(header);
			trace(body);
			return body.toString();
		}
		
		public function readObjectBytes(file:String):ByteArray {
			var bytes:ByteArray = new ByteArray;
			
			var path:String = gitDirectory + '/' + file;
			var f:File = new File(path);
			var fileStream:FileStream = new FileStream(); 
			fileStream.open(f, FileMode.READ); 
			fileStream.readBytes(bytes);
			fileStream.close();
			return bytes;
		}


		// should return something like refs/heads/master
		public function headRef():String {
			var head:String = readHead();
			var ref:Array = head.match(/ref: (.*)/);
			return ref[1];
		}
		
		// should return the symbolic ref of the current branch
		public function readHead():String {
			return readGitFile("HEAD");
		}

        public function readGitFile(filenm:String):String
        {
			var path:String = gitDirectory + '/' + filenm;
			var f:File = new File(path);
			var fileStream:FileStream = new FileStream(); 
			fileStream.open(f, FileMode.READ); 
			var results:String = fileStream.readUTFBytes(f.size);
			fileStream.close();
			return results;
        }
	}
}