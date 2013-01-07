package catyping 
{
	/**
	 * ...
	 * @author pardoman
	 */
	public class WordDictionary 
	{
		private var words:Array = new Array; /*String*/
		private var nonUsedWords:Array = new Array; /*Int*/
		
		public function WordDictionary() 
		{
			words.push("Fede");
			words.push("Mar");
			words.push("Xime");
			words.push("gato");
			words.push("mar");
			words.push("río");
			words.push("de");
			words.push("Janeiro");
			words.push("queso");
			words.push("caipiroska");
			words.push("mojito");
			words.push("daikiri");
			words.push("caipirinha");
			words.push("Olga");
			words.push("tango");
			words.push("awww");
			words.push("pomarola");
			words.push("salsa");
			words.push("Facebook");
			words.push("cat");
			words.push("miaw");
			words.push("neko");
			words.push("ginkgo");
			words.push("biloba");
			words.push("reddit");
			words.push("upvote");
			words.push("downvote");
			words.push("hola");
			words.push("stammtisch");
			words.push("halo");
			words.push("arroz");
			words.push("pollo");
			words.push("vinito");
			words.push("Dabezies");
			words.push("Medina");
			words.push("Lasserre");
			words.push("geología");
			words.push("piedras");
			words.push("traducción");
			words.push("MLE");
			words.push("YMLE");
			words.push("traductor");
			words.push("público");
			words.push("pública");
			words.push("púbica");
			words.push("duquesa");
			words.push("Uruguay");
			words.push("Montevideo");
			words.push("rambla");
			words.push("carrasco");
			words.push("brazo");
			words.push("oriental");
			words.push("malvín");
			words.push("cool");
			words.push("estoy");
			words.push("pc");
			words.push("mac");
			words.push("iPad");
			words.push("jengibre");
			words.push("traducir");
			words.push("Koshka");
			words.push("video");
			words.push("casero");
			words.push("mano");
			words.push("arañada");
			words.push("vaquero");
			words.push("gris");
			words.push("jean");
			words.push("pantalón");
			words.push("tacos");
			words.push("mosquito");
			words.push("moquitos");
			words.push("dactilografía");
			words.push("for");
			words.push("the");
			words.push("win");
			words.push("kitty");
			
			//Create indexes list
			createIndexList();
		}
		
		private function createIndexList():void 
		{
			nonUsedWords = new Array;
			
			for (var i:int = 0; i < words.length; ++i)
				nonUsedWords.push(i);
		}
		
		public function GetRandomWord():String
		{
			var index:int = Math.floor(Math.random() * nonUsedWords.length);
			var wordIndex:int = int(nonUsedWords[index]);
			nonUsedWords.splice(index, 1);
			
			if (nonUsedWords.length == 0)
				createIndexList();
				
			return words[wordIndex];
		}
		
	}

}